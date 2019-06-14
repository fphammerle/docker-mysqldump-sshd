#!/bin/sh
set -e

if [ ! -f "$SSHD_HOST_KEYS_DIR/rsa" ]; then
    ssh-keygen -t rsa -b 4096 -N '' -C '' -f "$SSHD_HOST_KEYS_DIR/rsa"
fi

if [ -z "$USERS" ]; then
    echo '$USERS is not set'
    exit 1
fi

IFS=','
for USER in $USERS; do
    if ! id "$USER" 2>/dev/null >/dev/null ; then
        (set -x; adduser -D "$USER")
        # default after `adduser -D`: !
        # > User alice not allowed because account is locked
        # `passwd -u` sets an empty password,
        # so better insert '*' manually
        # https://unix.stackexchange.com/a/193131/155174
        sed -i "s/^${USER}:!:/${USER}:*:/" /etc/shadow
    fi
done

set -x

sed -i "s/^AllowUsers .*/AllowUsers ${USERS//,/ }/" /etc/ssh/sshd_config

exec "$@"
