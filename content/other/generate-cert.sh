#!/bin/bash
# Description: Generate certificate for service

if [[ "$1" == "" ]]; then
    echo -e "ERROR: Service name should be provided as first argument\n"
    exit 1
fi

for file in ca.pem ca-key.pem ca-config.json ; do
    if [[ ! -f ${file} ]]; then
        echo "ERROR: File ${file} is missing, please run generate-ca.sh first"
    fi
done

SERVICE_NAME="$1"
NAMESPACE="quay-enterprise"
ROUTE_HOST_PIT="${SERVICE_NAME}.${NAMESPACE}.apps.pit-fed.e2e.bos.redhat.com"
ROUTE_HOST_LEO="${SERVICE_NAME}.${NAMESPACE}.apps.leo-fed.e2e.bos.redhat.com"
ROUTE_HOST_AWS="${SERVICE_NAME}.${NAMESPACE}.apps.aws-fed.e2e.bos.redhat.com"

sans="localhost,localhost.localdomain,127.0.0.1,${ROUTE_HOST_PIT},${ROUTE_HOST_LEO},${ROUTE_HOST_AWS},${SERVICE_NAME},${SERVICE_NAME}.${NAMESPACE},${SERVICE_NAME}.${NAMESPACE}.svc.cluster.local"


cat > ${1}-csr.json <<EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Austin",
      "O": "Kubernetes",
      "OU": "TX",
      "ST": "Texas"
    }
  ]
}
EOF

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -hostname=${sans} -profile=kubernetes ${1}-csr.json | cfssljson -bare ${1}
