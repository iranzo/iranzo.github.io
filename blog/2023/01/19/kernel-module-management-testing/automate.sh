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

export KUBECONFIG=/root/.kcli/clusters/hub/auth/kubeconfig

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

oc create ns kmm-jobs-test

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

MAXSPOKE=4

for spoke in $(seq 1 ${MAXSPOKE}); do
    export KUBECONFIG=/root/.kcli/clusters/cluster${spoke}/auth/kubeconfig

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
    oc create ns kmm-tests

done

export KUBECONFIG=/root/.kcli/clusters/hub/auth/kubeconfig
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
    cluster.open-cluster-management.io/clusterset: ""
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
