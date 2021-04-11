# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- `openssh-server`: added `ed25519` host key
- `docker-compose`: added cpu & memory resource limits

### Changed
- `openssh-server`: listen on port `2200` (previously `2222`)
- `docker-compose`: read-only container root filesystem

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

[Unreleased]: https://github.com/olivierlacan/keep-a-changelog/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/fphammerle/docker-mysqldump-sshd/releases/tag/v1.0.0
