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

if [ -z "$MYSQLDUMP_ARGS" ]; then
    echo -e 'missing environment variable MYSQLDUMP_ARGS\n' >&2
    set -x
    mysqldump --help
    exit 1
fi
echo -e "#!/bin/sh\nexec mysqldump $MYSQLDUMP_ARGS" > /tmp/mysqldump.sh
chmod u+x /tmp/mysqldump.sh

exec "$@"
