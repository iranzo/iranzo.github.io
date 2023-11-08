---
author: Pablo Iranzo Gómez
title: OpenShift Layered Images for patching
tags:
  - OpenShift
  - CoreOS
  - Custom images
date: 2023-11-08 00:00:00 +0200
categories:
  - tech
lastmod: 2023-11-08T11:10:18.237Z
---

With recent releases of OpenShift like 4.13 you can use [CoreOS Layering](https://access.redhat.com/documentation/es-es/openshift_container_platform/4.13/html/post-installation_configuration/coreos-layering) to apply custom images to the nodes.

The feature allows to build, via a `Dockerfile` a custom image that can later be applied to our nodes.

Let's review the steps:

1. First we need to find the base image being used in our environment with `oc adm release info quay.io/openshift-release-dev/ocp-release:4.13.5-aarch64 --image-for=rhel-coreos`
1. Then we use the returned value in the `FROM` line in our Dockerfile
1. If we want to add custom packages, we should have a server which is reachable and run `createrepo` on the folder containing the rpm's so that `rpm-ostree` can download them for installation.

Example dockerfile:

```dockerfile
# Filled from the value obtained at 1st step
FROM quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:394b83e0d67ea49314ba250e6e32710c5a7b807a19746c19f4f16d350b8636dd


RUN echo -e '[rt]\nbaseurl=http://192.168.53.117/RTARM/\nenabled=1\ngpgcheck=0\n' > /etc/yum.repos.d/rtkernel.repo

# Note the following command is documented with a different approach, but this one is working, a bug was raised for fixing official docs.
RUN rpm-ostree cliwrap install-to-root /

# Perform the package installation step, in this case, removing the original kernel and installing another kernel instead
RUN rpm-ostree override remove kernel{,-core,-modules,-modules-extra,-modules-core} --install=gobject-introspection --install=hdparm --install=kernel-rt --install=kernel-rt-core --install=kernel-rt-modules-core --install=libperf --install=libtraceevent --install=python3-dbus --install=python3-linux-procfs --install=python3-perf --install=python3-six --install=realtime-setup --install=tuna --install=tuned --install=tuned-profiles-realtime --install=virt-what --install=python3-pyudev --install=python3-gobject-base --install=kernel-rt-modules --install=python3-gobject-base-noarch
RUN     rpm-ostree cleanup -m
RUN    ostree container commit
```

Later, to build the container we will execute `podman build . --authfile /var/lib/kubelet/config.json` so that it has access to download the required images (`FROM` field).

And we're ready to push our newly created image to the registry, for example, if our image id is: `b2d0af2a733`

So as last step we can perform `podman push b2d0af2a733 quay.io/youruser/yourimage:tag` to upload the image for later consumption.

Then, we prepare a manifest for applying the change by MCO:

```yaml
apiVersion: machineconfiguration.openshift.io/v1
kind: MachineConfig
metadata:
  labels:
    machineconfiguration.openshift.io/role: master
  name: rhcos-kernelrt
spec:
  osImageURL: myregistry/user/kcoreos-9:kernelrt
```

And later apply with `oc apply -f mycustomkernel.yaml`... MCO will take over and will start rolling out the change as we can monitor with `oc describe mc rendered-master-XXXXXX`.

If you want to rollback the change, we can of course, perform `oc delete -f mycustomerkernel.yaml` and MCO will revert the change.

We can check current booted OS image with `rpm-ostree status`:

```console
sh-5.1# rpm-ostree  status
State: idle
Deployments:
* ostree-unverified-registry:myregistry/user/kcoreos-9:kernelrt
                   Digest: sha256:802d2f6bf8a6aef02c90ee1212de03f1888772dec6b34ab0dae97272cd6a917c
                  Version: 413.92.202307140015-0 (2023-11-07T17:16:18Z)
```

Enjoy!
