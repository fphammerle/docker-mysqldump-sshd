# docker: openssh-server invoking mysqldump 💾 🐳

Create logical backups of [mariadb](https://mariadb.com/kb/en/backup-and-restore-overview/) and [mysql](https://dev.mysql.com/doc/refman/5.7/en/backup-types.html) databases via SSH.

Whenever a SSH client connects `mysqldump` will be executed.

Useful to fetch backups via [rsnapshot](https://rsnapshot.org/).
See [rsnapshot.conf.example](rsnapshot.conf.example).

```sh
$ sudo docker run --rm --name mysqldump_ssh \
    -p 2200:2200 \
    -e SSH_CLIENT_PUBLIC_KEYS="$(cat ~/.ssh/id_*.pub)" \
    --tmpfs /home/dump/.ssh:mode=1777,size=16k \
    -e MYSQLDUMP_ARGS='--host=dbhost --user=dbuser --password=dbpass --all-databases' \
    --read-only --security-opt=no-new-privileges --cap-drop=ALL \
    docker.io/fphammerle/mysqldump-sshd
$ ssh -p 2200 -T dump@localhost
-- MariaDB dump 10.17  Distrib 10.4.10-MariaDB, for Linux (x86_64)
--
-- Host: database    Database: demo
-- ------------------------------------------------------
[…]
```

Git tags `docker/*` contain signed docker image digests:
https://github.com/fphammerle/docker-mysqldump-sshd/tags

### Docker Compose 🐙

1. `git clone https://github.com/fphammerle/docker-mysqldump-sshd`
2. `cd docker-mysqldump-sshd`
3. Adapt `$MYSQLDUMP_ARGS` in `docker-compose.yml`
4. `docker-compose up --build`
5. Add `authorized_keys` to docker volume `mysqldumpsshd_authorized_keys`.
