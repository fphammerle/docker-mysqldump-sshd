# docker: rsync & openssh-server 🐳

repo: https://github.com/fphammerle/docker-rsync-sshd

docker hub: https://hub.docker.com/r/fphammerle/rsync-sshd

## example 1

```sh
$ docker run --name=rsync-sshd -p 2022:22 -e USERS=alice,bob fphammerle/rsync-sshd
$ docker cp alice-keys rsync-sshd:/home/alice/.ssh/authorized_keys
$ docker cp bob-keys rsync-sshd:/home/bob/.ssh/authorized_keys
```

## example 2

```
$ docker run --name rsync-sshd \
    --publish 2022:22 --env USERS=alice,bob \
    --volume host-keys:/etc/ssh/host_keys \
    --volume alice-ssh-config:/home/alice/.ssh:ro \ 
    --volume bob-ssh-config:/home/bob/.ssh:ro \ 
    --init --rm \
    fphammerle/rsync-sshd
$ ssh -l alice -p 2022 localhost id
uid=1000(alice) gid=1000(alice) groups=1000(alice)
```
