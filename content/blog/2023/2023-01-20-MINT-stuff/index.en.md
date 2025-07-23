---
author: Pablo Iranzo Gómez
title: Management Integration whereabouts
tags:
  - Solutions Engineering
  - Management Integration
  - Red Hat
layout: list
date: 2023-01-19 9:00:00 +0100
categories:
  - presentations
outputs:
  - Reveal
reveal_hugo.theme: solarized
lastmod: 2025-07-23T07:46:24.792Z
---

## Management Integration whereabouts

---

### The Team

- Manager (TBF) (Scott in the interim)
  - Eran (TLV)
  - Pablo (VLC)
  - [Backfills](https://global-redhat.icims.com/jobs/96128/ecosystem-field-engineer--industrial-and-edge/job?hub=7): contact Scott if interested

---

### What we've done so far?

- ZTP Factory Workflow
- Kernel Module Management
- NVIDIA Bluefield support
- OpenShift Virtualization with vGPU
- Other supporting tasks

---

{{% section %}}

### ZTP Factory Workflow

- ZTP Stands for Zero Touch Provisioning: Automated OpenShift deployment that setup registry mirror, nodes,etc out of a configuration yaml.

- The architecture was described as Openshift Container Agnostic TOPology Integrated Chassis. The architecture was based on a 3+1 chassis which had everything needed for the automation with nics for internal/external networks.

---

### ZTPFW (cont)

- Simplifies hardware manufacturer setup in an automated and repetitive way OpenShift clusters that are ready to be shipped to customer premises to final setup and utilization.
- Uses OpenShift, ACM, Quay, etc.
- Used as foundation layer for other efforts
  - Automatic reconnection to ACM Hub

---

### ZTP Use cases

- Prepare clusters ready to be deployed close to customer needs (concerts, supermarkets, etc.)
- Disconnected environments that might reconnect after time for updates, (ACM Spoke import), f.e. Cargo ship, etc.

{{% /section %}}

---

### Kernel Module Management

It's an operator that builds custom kernel modules to provide support for specific hardware in the systems.

About to get 1.0 released with some features coming for 1.1:

- Disconnected operation
- Hub-Spoke approach (Hub can build the modules for resource-stretched spokes)

---

{{% section %}}

### Nvidia Bluefield2 DPU

What is a DPU? :

- DPU ( Data processing unit) it's a PCIE card that runs as a system-on-chip inside the host. The System is based on ARM and hosts its own OS and even a BMC.

---

### How can it be used?

The DPU is can be used in several ways:

- Offload traffic from the host to the DPU - SSL encrypt/decrypt, IPSEC, etc..
- NVME over LAN
- Security enforcement
- Software defined infrastructure

---

### How is DPU used in Openshift?

The Current design is using Shared-OVN with 2 clusters:

- Infrastructure cluster
- Tenant cluster

The cluster will communicate between them and setup a shared OVN network for offloading POD’s traffic

Links:

- [Nvidia DPU](https://www.nvidia.com/en-us/networking/products/data-processing-unit/)

---

### DMA-BUF for GPU RDMA

DMA what?

RDMA is a kernel feature to share buffers between hosts. The general idea is setting up a peer-to-peer DMA between NIC and transferring / sharing buffers for GPU workloads.

Starting in RHCOS 9 :

- [OpenFabrics GPU DMA](https://www.openfabrics.org/wp-content/uploads/2020-workshop-presentations/303.-OFI-GPU-DMA-BUF-OFA2020v2.pdf)

{{% /section %}}

---

{{% section %}}

### Openshift Virtualization with vGPU

In the old way, each VM we create has a PCIE pass-through to GPU. which means that only one application / service can run on one GPU.

The Nvidia GPU operator is now extended and supports vGPU - taking one physical GPU and sharing to multiple instances.

---

### MIG with GPU operator

The next evolution of GPU is using MIG ( multi instance GPU ) which partition a GPU based on Ampere architecture ( A100 + ) to different hardware slices which is more secure /isolated and better performance.

Links:

- [Nvidia OCP Virt](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/openshift/openshift-virtualization.html)
- [Nvidia MIG](https://docs.nvidia.com/datacenter/tesla/mig-user-guide/index.html)

{{% /section %}}

---

### Other tasks

- Scale testing of ACM Deployment
- Scale testing of KMM deployment

---

## Questions?
