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
        passwd -u "$USER" 2>/dev/null
    fi
done

set -x

sed -i "s/^AllowUsers .*/AllowUsers ${USERS//,/ }/" /etc/ssh/sshd_config

exec "$@"
