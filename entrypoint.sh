#!/bin/sh
set -e

if [ ! -f "$SSHD_HOST_KEYS_DIR/rsa" ]; then
    ssh-keygen -t rsa -b 4096 -N '' -C '' -f "$SSHD_HOST_KEYS_DIR/rsa"
fi

echo -e "#!/bin/sh\nexec mysqldump $MYSQLDUMP_ARGS" > /tmp/mysqldump.sh
chmod u+x /tmp/mysqldump.sh

exec "$@"
