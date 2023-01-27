---
author: Pablo Iranzo Gómez
title: Enable rootless podman on Fedora
tags:
  - Fedora
  - podman
  - containers
  - rootless
  - FOSS
date: 2023-01-27 9:00:00 +0100
categories:
  - tech
modified: 2023-01-27T10:26:25.806Z
---

With podman we can setup containers for being used for non root users by performing some simple steps:

## Install required packages

```bash
dnf -y install slirp4netns fuse-overlayfs crun podman shadow-utils
```

Force the number of user namespaces (might be required on some environments):

```bash
echo "user.max_user_namespaces=28633" > /etc/sysctl.d/userns.conf
sysctl -p /etc/sysctl.d/userns.conf
```

## Delegate

Allows to define which resources are available[^1]:

[^1]: <https://github.com/containers/podman/blob/main/troubleshooting.md#26-running-containers-with-resource-limits-fails-with-a-permissions-error>

```sh
mkdir -p /etc/systemd/system/user@.service.d

cat << EOF > /etc/systemd/system/user@.service.d/delegate.conf
[Service]
Delegate=cpu cpuset io memory pids
EOF
```

To verify it has been done correctly, logout and login with the user and execute:

```sh
cat "/sys/fs/cgroup/user.slice/user-$(id -u).slice/user@$(id -u).service/cgroup.controllers"
```

The output will be: `cpuset cpu memory pids`

## Set `uids`/`gids`

For user to do proper mapping on the containers[^2], we need to define non-overlapping ranges for our user, let's say `kni` and store it in the files: `/etc/subuid` and `/etc/subgid`:

[^2]: Check <https://github.com/containers/podman/blob/main/troubleshooting.md#10-rootless-setup-user-invalid-argument>

```sh
cat /etc/subuid
kni:200000:65536
```

```sh
cat /etc/subgid
kni:200000:65536
```

Ranges should not overlap with real users in the system, or the container

## Wrap up

After following above steps, it should be possible to run containers with rootless users, we can verify we can get the ranges with:

```bash
podman run  --rm --cpus=0.42 --memory=42m --pids-limit 42 -w /sys/fs/cgroup docker.io/library/alpine cat cpu.max memory.max pids.max
```

The output should be something like:

```console
42000 100000
44040192
42
```

Enjoy!
