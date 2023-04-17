---
title: Kernel Module Management testing
tags:
  - Kcli
  - Kubernetes
  - OpenShift
  - Open Cluster Management
  - ACM
  - Advanced Cluster Management
  - Kernel Module Management
  - KMM
categories:
  - tech
date: 2023-01-19T08:55:11.435Z
modified: 2023-04-17T21:39:29.153Z
---

Following on the [Using Kcli to prepare for OCM testing]({{% relref "2022-12-23-using-kcli-to-prepare-for-open-cluster-management-testing.en.md" %}}), we're going to prepare KMM testing in Hub-Spoke approach.

First we need to prepare our `.docker/config.json` with the contents of our OpenShift pull secret used with `Kcli`.

```bash
mkdir -p ~/.docker/
cp openshift_pull.json ~/.docker/config.json
```

## Warning advisories

{{<note>}}
Semi-scripted version available at [automate.sh](automate.sh)
{{</note>}}

{{<warning>}}
We're using pre-release bits of the software, that's why we need to define a custom catalog for both the Hub and the Spokes. Once KMM is released it will be available from the official one and just the Policy will be needed.
{{</warning>}}

{{<danger>}}
Ensure that `podman login quay.io` is working correctly so that we can push the built images.
{{</danger>}}

{{<hint title="Using `podman` instead of `docker`">}}
If you're using `podman` like we'll do, we need to create a symbolic link for the command to the `docker` name, as the `Makefile` does use `docker`.

```sh
ln -s /usr/bin/podman /usr/bin/docker
```

{{</hint>}}

## Testing KMM Hub&Spoke on OpenShift

KMM allows OpenShift to build required Kernel modules for the nodes, for example to take advantage of certain network cards or hardware that is required for operations.

### Dependencies

- `registry.ci.openshift.org` token - [Documentation](https://docs.ci.openshift.org/docs/how-tos/use-registries-in-build-farm/#how-do-i-log-in-to-pull-images-that-require-authentication)

{{<warning title ="quay.io account repository accessibility">}}
if the repositories are not created beforehand, please make sure to convert them to public ones after pushing to them
{{</warning>}}

### Setup the Hub

1. Build and push the KMM-Hub container image, the KMM-Hub OLM bundle and catalog from the midstream repository:

   ```bash
   MYUSER=iranzo

   git clone git@github.com:rh-ecosystem-edge/kernel-module-management.git
   cd kernel-module-management

    # Build KMM-Hub container image

    HUB_IMG=quay.io/${MYUSER}/kernel-module-management-hub:latest make docker-build-hub

    # Push KMM-Hub container image

    HUB_IMG=quay.io/${MYUSER}/kernel-module-management-hub:latest make docker-push-hub

    # Generate KMM-Hub OLM bundle

    HUB_IMG=quay.io/${MYUSER}/kernel-module-management-hub:latest BUNDLE_IMG=quay.io/${MYUSER}/kernel-module-management-bundle-hub make bundle-hub

    # Build KMM-Hub OLM bundle container

    BUNDLE_IMG=quay.io/${MYUSER}/kernel-module-management-bundle-hub make bundle-build-hub

    # Push KMM-Hub OLM bundle container

    BUNDLE_IMG=quay.io/${MYUSER}/kernel-module-management-bundle-hub make bundle-push

    # Build KMM-Hub OLM catalog

    CATALOG_IMG=quay.io/${MYUSER}/kernel-module-management-catalog-hub:latest BUNDLE_IMGS=quay.io/${MYUSER}/kernel-module-management-bundle-hub make catalog-build

    # Push KMM-Hub OLM catalog

    CATALOG_IMG=quay.io/${MYUSER}/kernel-module-management-catalog-hub:latest make catalog-push
   ```

1. Deploy the KMM-Hub OLM catalog on the Hub:

   As mentioned earlier we need to perform this step as we're consuming pre-release bits, so the images are not available in the regular OpenShift catalog.

   ```bash
   cat <<EOF | oc apply -f -
   apiVersion: operators.coreos.com/v1alpha1
   kind: CatalogSource
   metadata:
     name: kmm-hub-catalog
     namespace: openshift-marketplace
   spec:
     sourceType: grpc
     image: quay.io/${MYUSER}/kernel-module-management-catalog-hub:latest
     displayName: KMM Hub Catalog
     publisher: ${MYUSER}
     updateStrategy:
       registryPoll:
         interval: 5m
   EOF
   ```

1. Deploy the KMM-Hub operator by creating an OLM Subscription:

   ```bash
   cat <<EOF | oc apply -f -
   apiVersion: operators.coreos.com/v1alpha1
   kind: Subscription
   metadata:
     name: kmm-operator
     namespace: openshift-operators
   spec:
     channel: alpha
     installPlanApproval: Automatic
     name: kernel-module-management-hub
     source: kmm-hub-catalog
     sourceNamespace: openshift-marketplace
   EOF
   ```

1. Deploy the ACM Policy that adds the required permissions to the Spoke `klusterlet`, in order for the latter to be able to CRUD KMM Module `CRs`:

   ```bash
   cat <<EOF | oc apply -f -
   ---
   apiVersion: policy.open-cluster-management.io/v1
   kind: Policy
   metadata:
     name: allow-klusterlet-deploy-kmm-modules
   spec:
     remediationAction: enforce
     disabled: false
     policy-templates:
       - objectDefinition:
           apiVersion: policy.open-cluster-management.io/v1
           kind: ConfigurationPolicy
           metadata:
             name: klusterlet-deploy-modules
           spec:
             severity: high
             object-templates:
             - complianceType: mustonlyhave
               objectDefinition:
                 apiVersion: rbac.authorization.k8s.io/v1
                 kind: ClusterRole
                 metadata:
                   name: kmm-module-manager
                 rules:
                   - apiGroups: [kmm.sigs.x-k8s.io]
                     resources: [modules]
                     verbs: [create, delete, get, list, patch, update, watch]
             - complianceType: mustonlyhave
               objectDefinition:
                 apiVersion: rbac.authorization.k8s.io/v1
                 kind: RoleBinding
                 metadata:
                   name: klusterlet-kmm
                   namespace: open-cluster-management-agent
                 subjects:
                 - kind: ServiceAccount
                   name: klusterlet-work-sa
                   namespace: open-cluster-management-agent
                 roleRef:
                   kind: ClusterRole
                   name: kmm-module-manager
                   apiGroup: rbac.authorization.k8s.io
   ---
   apiVersion: apps.open-cluster-management.io/v1
   kind: PlacementRule
   metadata:
     name: all-clusters-except-local
   spec:
     clusterSelector:
       matchExpressions:
         - key: name
           operator: NotIn
           values:
             - local-cluster
   ---
   apiVersion: policy.open-cluster-management.io/v1
   kind: PlacementBinding
   metadata:
     name: bind-klusterlet-kmm-all-clusters
   placementRef:
     apiGroup: apps.open-cluster-management.io
     kind: PlacementRule
     name: all-clusters-except-local
   subjects:
     - apiGroup: policy.open-cluster-management.io
       kind: Policy
       name: allow-klusterlet-deploy-kmm-modules
   EOF
   ```

1. Create a namespace on the Hub, in which the Build and Sign jobs will be created:

   ```bash
   oc create ns kmm-jobs-test
   ```

### Setup the Spoke

1. Build and push the KMM container image, the KMM OLM bundle and catalog from midstream repository:

   Again, we need to perform this step as we're consuming pre-release bits, so the images are not available in the regular OpenShift catalog.

   ```bash
     # Build KMM container image
     IMG=quay.io/${MYUSER}/kernel-module-management:latest make docker-build

     # Push KMM container image
     IMG=quay.io/${MYUSER}/kernel-module-management:latest make docker-push

     # Generate KMM OLM bundle
     IMG=quay.io/${MYUSER}/kernel-module-management:latest BUNDLE_IMG=quay.io/${MYUSER}/kernel-module-management-bundle make bundle

     # Build KMM OLM bundle container
     BUNDLE_IMG=quay.io/${MYUSER}/kernel-module-management-bundle make bundle-build

     # Push KMM OLM bundle container
     BUNDLE_IMG=quay.io/${MYUSER}/kernel-module-management-bundle make bundle-push

     # Build KMM OLM catalog
     CATALOG_IMG=quay.io/${MYUSER}/kernel-module-management-catalog:latest BUNDLE_IMGS=quay.io/${MYUSER}/kernel-module-management-bundle make catalog-build

     # Push KMM OLM catalog
     CATALOG_IMG=quay.io/${MYUSER}/kernel-module-management-catalog:latest make catalog-push
   ```

1. Deploy the KMM catalog on the Spoke:

   ```bash
   cat <<EOF | oc apply -f -
   apiVersion: operators.coreos.com/v1alpha1
   kind: CatalogSource
   metadata:
     name: kmm-catalog
     namespace: openshift-marketplace
   spec:
     sourceType: grpc
     image: quay.io/${MYUSER}/kernel-module-management-catalog:latest
     displayName: KMM Catalog
     publisher: ${MYUSER}
     updateStrategy:
       registryPoll:
         interval: 5m
   EOF
   ```

1. Deploy the KMM operator by creating an OLM Subscription:

   ```bash
   cat <<EOF | oc apply -f -
   apiVersion: operators.coreos.com/v1alpha1
   kind: Subscription
   metadata:
     name: kernel-module-management
     namespace: openshift-operators
   spec:
     channel: alpha
     config:
       env:
       - name: KMM_MANAGED
         value: "1"
     installPlanApproval: Automatic
     name: kernel-module-management
     source: kmm-catalog
     sourceNamespace: openshift-marketplace
   EOF
   ```

1. Create a namespace on the Spoke, in which the `Module` will be created

   ```bash
   oc create ns kmm-tests
   ```

### Create a `ManagedClusterModule` on the Hub

The following `ManagedClusteModule` includes a selector for the `default` `clusterset`.

{{<warning>}}
In this example, we've created manually a docker secret in order to allow KMM-Hub to push the newly generated module container image to my [quay.io](http://quay.io) repository. For example:

````bash
cat <<EOF | oc apply -f -
apiVersion: v1
data:
  .dockerconfigjson: THISISWHEREMYSECRET GOES
kind: Secret
metadata:
  name: ${MYUSER}-quay-cred
  namespace: kmm-jobs-test
type: kubernetes.io/dockerconfigjson
EOF
{{</warning>}}



{{<note>}}
Pay attention to the cluster selector in the example below:
```yaml
selector:
  cluster.open-cluster-management.io/clusterset: default
````

So that it targets one of your clusters.

{{</note>}}

1. Deploy a `ManagedClusterModule` to test the setup e2e:

   And now, the manifest itself:

   ```bash
   cat <<EOF | oc apply -f -
   apiVersion: v1
   kind: ConfigMap
   metadata:
     name: mod-example
     namespace: kmm-jobs-test
   data:
     dockerfile: |
       FROM image-registry.openshift-image-registry.svc:5000/openshift/driver-toolkit as builder
       ARG KERNEL_VERSION
       ARG MY_MODULE
       WORKDIR /build
       RUN git clone https://github.com/cdvultur/kmm-kmod.git
       WORKDIR /build/kmm-kmod
       RUN cp kmm_ci_a.c mod-example.c
       RUN make

       FROM registry.redhat.io/ubi8/ubi-minimal
       ARG KERNEL_VERSION
       ARG MY_MODULE
       RUN microdnf -y install kmod
       COPY --from=builder /usr/bin/kmod /usr/bin/
       RUN for link in /usr/bin/modprobe /usr/bin/rmmod; do \
           ln -s /usr/bin/kmod "\$link"; done
       COPY --from=builder /etc/driver-toolkit-release.json /etc/
       COPY --from=builder /build/kmm-kmod/*.ko /opt/lib/modules/\${KERNEL_VERSION}/
       RUN depmod -b /opt \${KERNEL_VERSION}
   ---
   apiVersion: hub.kmm.sigs.x-k8s.io/v1beta1
   kind: ManagedClusterModule
   metadata:
     name: mod-example
   spec:
     spokeNamespace: kmm-tests
     jobNamespace: kmm-jobs-test
     selector:
       cluster.open-cluster-management.io/clusterset: default
     moduleSpec:
       imageRepoSecret:
         name: ${MYUSER}-quay-cred
       moduleLoader:
         container:
           modprobe:
             moduleName: mod-example
           imagePullPolicy: Always
           kernelMappings:
           - regexp: '^.+$'
             containerImage: quay.io/${MYUSER}/module:\${KERNEL_FULL_VERSION}
             pull:
               insecure: true
               insecureSkipTLSVerify: true
             build:
               buildArgs:
                 - name: MY_MODULE
                   value: mod-example.o
               dockerfileConfigMap:
                 name: mod-example
       selector:
         node-role.kubernetes.io/worker: ""
   EOF
   ```

1. Check the respective build on the Hub:

   ```bash
   oc get builds -n kmm-jobs-test
   ```

1. After the build is completed, the respective `ManifestWork` will be created:

   ```bash
   oc get manifestworks -n <spoke-cluster-name>
   ```

1. Check whether the KMM Module is created on the Spoke:

   ```bash
   oc get modules -n kmm-tests
   ```

1. Check the KMM `ModuleLoader` `DaemonSet` on the Spoke:

   ```bash
   oc get ds -n kmm-tests
   ```

   {{<enjoy>}}
