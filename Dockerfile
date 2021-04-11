FROM docker.io/alpine:3.13.4

ARG MARIADB_CLIENT_PACKAGE_VERSION=10.5.8-r0
ARG OPENSSH_PACKAGE_VERSION=8.4_p1-r3
ARG TINI_PACKAGE_VERSION=0.19.0-r0
ARG USER=dump
ENV SSHD_HOST_KEYS_DIR=/etc/ssh/host_keys
RUN apk add --no-cache \
        mariadb-client=$MARIADB_CLIENT_PACKAGE_VERSION \
        openssh-server=$OPENSSH_PACKAGE_VERSION \
        tini=$TINI_PACKAGE_VERSION \
    && adduser -S -s /bin/ash "$USER" \
    && mkdir "$SSHD_HOST_KEYS_DIR" \
    && chown -c "$USER" "$SSHD_HOST_KEYS_DIR"
VOLUME $SSHD_HOST_KEYS_DIR

# RUN apk add --no-cache man openssh-doc=$OPENSSH_PACKAGE_VERSION

COPY sshd_config /etc/ssh/sshd_config
EXPOSE 2200/tcp

ENV MYSQLDUMP_ARGS=
COPY entrypoint.sh /
ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]

USER $USER
CMD ["/usr/sbin/sshd", "-D", "-e"]
