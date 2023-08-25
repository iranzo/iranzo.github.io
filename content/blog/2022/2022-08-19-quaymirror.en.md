---
title: Setup a Quay mirror for offline installations with mirror-registry
date: 2022-08-19T10:00:35.086Z
lang: en
tags:
  - Container
  - FOSS
  - Kubernetes
  - OpenShift
  - Quay
  - Registry
categories:
  - FOSS
slug: setup-quay-mirror-disconnected-installations-mirror-registry
description: Learn on how to use mirror-registry to create a local copy that can be used to install OpenShift without external Internet connectivity.
lastmod: 2023-08-25T09:45:44.516Z
---

In order to setup disconnected registry for installation, follow this blog post by Daniel at [Introducing Mirror Registry for Red Hat OpenShift](https://cloud.redhat.com/blog/introducing-mirror-registry-for-red-hat-openshift).

At the end of the process it will output something like:

```log
INFO[2022-08-19 07:10:22] Quay installed successfully, permanent data is stored in /etc/quay-install
INFO[2022-08-19 07:10:22] Quay is available at https://${HOSTNAME}:8443 with credentials (init, ${PASSWORDSTRING})
```

Once the setup is done, remember several steps:

- Edit `/etc/containers/registries.conf` to add relevant entries for our registry as required:
  ```ini
  [[registry]]
  insecure=true
  location="${MYHOSTNAME}:8443"
  ```
- Add the pull-secret information to the `pull-secret.txt` file, along with the other entries you might had:

  ```json
   "${MYHOSTNAME}:8443": {
      "auth": "BASE64_ENCODED_USERNAME:PASSWORD",
      "email": ""
    }

  ```

Now, we're ready to do the mirroring itself part, so let's prepare the required variables:

```sh
export OCP_RELEASE="4.10.0"
export LOCAL_REGISTRY="`hostname`:8443"
export LOCAL_REPOSITORY="ocp4/openshift4"
export PRODUCT_REPO="openshift-release-dev"
export LOCAL_SECRET_JSON="pull_secret.txt"
export RELEASE_NAME="ocp-release"
export ARCHITECTURE="x86_64"
```

And, let's perform the mirroring itself

```sh
oc adm release mirror -a ${LOCAL_SECRET_JSON} --from=quay.io/${PRODUCT_REPO}/${RELEASE_NAME}:${OCP_RELEASE}-${ARCHITECTURE} --to=${LOCAL_REGISTRY}/${LOCAL_REPOSITORY} --to-release-image=${LOCAL_REGISTRY}/${LOCAL_REPOSITORY}:${OCP_RELEASE}-${ARCHITECTURE}
```

Once this process finishes, it will output information regarding the `ICSP` (`ImageContentSourcePolicy`) and the snippet we should add to OpenShift installer `install-config.yaml` to use this mirror instead of the original registries for install time:

```log
To use the new mirrored repository to install, add the following section to the install-config.yaml:

imageContentSources:
- mirrors:
  - ${HOSTNAME}:8443/ocp4/openshift4
  source: quay.io/openshift-release-dev/ocp-release
- mirrors:
  - ${HOSTNAME}:8443/ocp4/openshift4
  source: quay.io/openshift-release-dev/ocp-v4.0-art-dev


To use the new mirrored repository for upgrades, use the following to create an ImageContentSourcePolicy:

apiVersion: operator.openshift.io/v1alpha1
kind: ImageContentSourcePolicy
metadata:
  name: example
spec:
  repositoryDigestMirrors:
  - mirrors:
    - ${HOSTNAME}:8443/ocp4/openshift4
    source: quay.io/openshift-release-dev/ocp-release
  - mirrors:
    - ${HOSTNAME}:8443/ocp4/openshift4
    source: quay.io/openshift-release-dev/ocp-v4.0-art-dev
```

{{<enjoy>}}
