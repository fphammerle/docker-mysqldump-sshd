FROM alpine:3.13.4

ARG MARIADB_CLIENT_PACKAGE_VERSION=10.5.8-r0
ARG OPENSSH_PACKAGE_VERSION=8.4_p1-r3
ARG TINI_PACKAGE_VERSION=0.19.0-r0
RUN apk add --no-cache \
        mariadb-client=$MARIADB_CLIENT_PACKAGE_VERSION \
        openssh-server=$OPENSSH_PACKAGE_VERSION \
        tini=$TINI_PACKAGE_VERSION \
    && adduser -S dump

# RUN apk add --no-cache man openssh-doc=$OPENSSH_PACKAGE_VERSION

COPY entrypoint.sh /
ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]
COPY sshd_config /etc/ssh/sshd_config
ENV SSHD_HOST_KEYS_DIR /etc/ssh/host_keys
ENV MYSQLDUMP_ARGS --help
RUN chmod a=rx /entrypoint.sh \
    && chmod a=r /etc/ssh/sshd_config \
    && sed -i 's#^\(dump:.*\):/sbin/nologin$#\1:/tmp/mysqldump.sh#' /etc/passwd \
    && mkdir $SSHD_HOST_KEYS_DIR \
    && chown dump $SSHD_HOST_KEYS_DIR
VOLUME $SSHD_HOST_KEYS_DIR

USER dump
EXPOSE 2200/tcp
CMD ["/usr/sbin/sshd", "-D", "-e"]
