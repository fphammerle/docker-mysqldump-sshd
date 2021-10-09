FROM docker.io/alpine:3.14.2

ARG MARIADB_CLIENT_PACKAGE_VERSION=10.5.12-r0
ARG OPENSSH_SERVER_PACKAGE_VERSION=8.6_p1-r3
ARG TINI_PACKAGE_VERSION=0.19.0-r0
ARG USER=dump
ENV SSHD_HOST_KEYS_DIR=/etc/ssh/host_keys
RUN apk add --no-cache \
        mariadb-client=$MARIADB_CLIENT_PACKAGE_VERSION \
        openssh-server="$OPENSSH_SERVER_PACKAGE_VERSION" \
        tini=$TINI_PACKAGE_VERSION \
    && adduser -S -s /bin/ash "$USER" \
    && mkdir "$SSHD_HOST_KEYS_DIR" \
    && chown -c "$USER" "$SSHD_HOST_KEYS_DIR"
VOLUME $SSHD_HOST_KEYS_DIR

#RUN apk add --no-cache less man-db openssh-doc=$OPENSSH_SERVER_PACKAGE_VERSION

COPY sshd_config /etc/ssh/sshd_config
EXPOSE 2200/tcp

ENV MYSQLDUMP_ARGS=
COPY entrypoint.sh /
ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]

USER $USER
CMD ["/usr/sbin/sshd", "-D", "-e"]

# https://github.com/opencontainers/image-spec/blob/v1.0.1/annotations.md
ARG REVISION=
LABEL org.opencontainers.image.title="single-user openssh server executing mysqldump when client connects" \
    org.opencontainers.image.source="https://github.com/fphammerle/docker-mysqldump-sshd" \
    org.opencontainers.image.revision="$REVISION"
