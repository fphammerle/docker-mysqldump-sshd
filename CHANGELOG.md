# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Changed
- `sshd`: no longer accept RSA keys < 2048 bits for authentication

## [2.0.1] - 2021-06-20
### Fixed
- entrypoint: unset no longer needed `MYSQLDUMP_ARGS` variable

## [2.0.0] - 2021-04-11
### Added
- `openssh-server`: `ed25519` host key
- `docker-compose`: cpu & memory resource limits
- image labels:
  - `org.opencontainers.image.revision` (git commit hash via build arg)
  - `org.opencontainers.image.source` (repo url)
  - `org.opencontainers.image.title`

### Changed
- authorize public keys in env var `SSH_CLIENT_PUBLIC_KEYS`
  (instead of mounting `/home/dump/.ssh/authorized_keys`)
- fail early when env var `MYSQLDUMP_ARGS` is not set
- `openssh-server`: listen on port `2200` (previously `2222`)
- `docker-compose`: read-only container root filesystem
- `docker-compose`: require version `2.3`

### Fixed
- `Dockerfile` & `docker-compose`: add registry to base image specifiers for `podman`
- `docker-compose`: drop capabilities, disallow gaining new privileges

### Removed
- `openssh-server`: disabled message authentication code algorithms
  `hmac-sha2-512`, `hmac-sha2-256` & `umac-128@openssh.com`
  (as recommended by `ssh-audit.com`)

## [1.0.0] - 2020-01-10
### Added
- openssh server invoking `mysqldump` when client connects

[Unreleased]: https://github.com/olivierlacan/keep-a-changelog/compare/v2.0.1...HEAD
[2.0.1]: https://github.com/olivierlacan/keep-a-changelog/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/olivierlacan/keep-a-changelog/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/fphammerle/docker-mysqldump-sshd/releases/tag/v1.0.0
