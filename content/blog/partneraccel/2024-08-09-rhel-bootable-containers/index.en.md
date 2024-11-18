---
title: RHEL bootable containers (BOOTC)
summary: Learn how to use a container for being the baseline for your computer, making it easier to operate the operating system installation and maintenance.
date: 2024-08-09T00:00:00.007Z
keywords:
  - RHEL
  - CentOS
  - Fedora
  - Container
  - podman
  - Docker
  - baremetal
lastmod: 2024-11-18T08:29:21.310Z
cover:
  image: cover.png
---

Containers have entered in the IT panorama since some time ago, and have helped streamline the process for many applications and its lifecycle management.

Containers require several pieces to run, like having the base OS running, the runtimes, etc so it's not something we can do on baremetal directly, but with the appearance of inmutable systems like CoreOS and later Fedora Silverblue, many users and products started to build on top of systems that were not touched directly but via extra layers applied with a tighter control over changes.

All of this starts with a `ContainerFile` which inherits from an image and performs actions for adding/removing and or configuring based on our needs, for example:

```Dockerfile
# Define the base image for the second stage

FROM registry.redhat.io/rhel9/rhel-bootc:latest

# Define packages to add
ARG EXTRA_RPM_PACKAGES='pciutils tmux joe bootc ostree openssh-server firefox gnome-kiosk gnome-kiosk-search-appliance gdm xorg-x11-drivers xorg-x11-fonts-75dpi xorg-x11-server-Xorg xorg-x11-xauth xorg-x11-xinit xorg-x11-xinit-session' # cloud-init

# Define packages to remove
ARG REMOVE_RPM_PACKAGES='adcli avahi-libs flashrom flatpak* fwupd gdisk libsmbclient libudisks2 nano ncurses netavark nfs-utils pipewire rpcbind samba-client-libs samba-common-libs sg3_utils skopeo sos sssd-ad sssd-common sssd-common-pac sssd-ipa sssd-krb5 sssd-krb5-common sssd-ldap sssd-nfs-idmap toolbox tracker tracker-miners udisks2 WALinuxAgent-udev wireplumber zstd'

RUN dnf remove -y ${REMOVE_RPM_PACKAGES}

RUN dnf autoremove -y

# Enable EPEL
RUN dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm

RUN mv /etc/selinux /etc/selinux.tmp && \
  dnf install -y \
  ${EXTRA_RPM_PACKAGES} \
  && dnf -y upgrade \
  && dnf clean all \
  && mv /etc/selinux.tmp /etc/selinux \
  && ln -s ../cloud-init.target /usr/lib/systemd/system/default.target.wants # Enable cloud-init

# Remove documentation, man pages and locales to free up space
RUN rm -Rfv /usr/share/info/ /usr/share/man/ /usr/share/doc/ /usr/share/locale/

RUN systemctl disable rhsmcertd

# Copy GDM autologin configuration
ADD config/gdm-custom.conf /etc/gdm/custom.conf

# DMRC was used in prior GNOME versions, use new path
ADD config/dmrc /var/lib/AccountsService/users/root

# Setup /usr/lib/containers/storage as an additional store for images.
# Remove once the base images have this set by default.
RUN grep -q /usr/lib/containers/storage /etc/containers/storage.conf || \
  sed -i -e '/additionalimage.*/a "/usr/lib/containers/storage",' \
  /etc/containers/storage.conf

# Added for running as an OCI Container to prevent Overlay on Overlay issues.
VOLUME /var/lib/containers

```

In this case, we'll be configuring autologin for the graphics session with the user we'll adding later

This is done via `/etc/gdm/custom.conf` file:

```ini
[daemon]
AutomaticLoginEnable=True
AutomaticLogin=root
```

And via Gnome configuration for user root:

```ini
[User]
Session=org.gnome.Kiosk.SearchApp.Session
SystemAccount=true

```

For assembling our container we use the following command:

```sh
podman build -f ContainerFile --squash
```

Once it has finished, we can assign a tag and a name for it, passing as MYID the value of the hash obtained in previous command:

```sh
OURCONTAINERTAG="quay.io/myuser/mybootccontainer"
podman tag $MYID ${OURCONTAINERTAG}

```

Last step is to start the container conversion into a RAW image, an ISO, a QCOW2, etc... but first adapt the configuration for creating our user:

Contents of `config.tmpl.json`:

```json
{
  "blueprint": {
    "customizations": {
      "user": [
        {
          "name": "root",
          "password": "linux123",
          "key": "$MYKEY",
          "home": "/var/roothome"
        }
      ]
    }
  }
}
```

So... let's build it!:

```sh
#!/bin/bash
mkdir -p output/
export MYKEY=$(cat ~/.ssh/id_rsa.pub)
envsubst <config.tmpl.json >config.json

# CentOS builder
IMAGE="quay.io/centos-bootc/bootc-image-builder:latest"

TYPE="--rootfs ext4 --type raw"
# For generating an ISO that starts anaconda and auto installs to disk
# TYPE="--type anaconda-iso"

podman run \
    --rm \
    -it \
    --privileged \
    --pull=always \
    --security-opt label=type:unconfined_t \
    -v $(pwd)/output:/output \
    -v /var/lib/containers/storage:/var/lib/containers/storage \
    -v $(pwd)/config.json:/config.json \
    ${IMAGE} \
    ${TYPE} \
    --local \
    ${OURCONTAINERTAG}

```

Once the process is finished in the `output` folder the raw image will be available for us to test with `virt-manager` or for using `dd` to write it to a USB-drive for baremetal testing.

{{<enjoy>}}
