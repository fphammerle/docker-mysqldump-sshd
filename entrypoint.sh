#!/bin/sh

set -eu

# sync with https://github.com/fphammerle/docker-gitolite/blob/master/entrypoint.sh
if [ ! -f "$SSHD_HOST_KEYS_DIR/rsa" ]; then
    ssh-keygen -t rsa -b 4096 -N '' -f "$SSHD_HOST_KEYS_DIR/rsa"
fi
if [ ! -f "$SSHD_HOST_KEYS_DIR/ed25519" ]; then
    ssh-keygen -t ed25519 -N '' -f "$SSHD_HOST_KEYS_DIR/ed25519"
fi
unset SSHD_HOST_KEYS_DIR

printenv SSH_CLIENT_PUBLIC_KEYS > ~/.ssh/authorized_keys
unset SSH_CLIENT_PUBLIC_KEYS

if [ -z "$MYSQLDUMP_ARGS" ]; then
    echo -e 'missing environment variable MYSQLDUMP_ARGS\n' >&2
    set -x
    mysqldump --help
    exit 1
fi
unset MYSQLDUMP_ARGS

exec "$@"
