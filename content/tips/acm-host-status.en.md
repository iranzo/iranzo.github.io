---
author: Pablo Iranzo Gómez
categories:
  - tech
  - Kubernetes
  - OpenShift
  - Advanced Cluster Management
  - ACM
  - Tips
title: Check Agent status per state
tags:
  - ACM
  - OpenShift
  - Agent
  - Tips
date: 2022-08-10T14:01:32.418Z
lastmod: 2023-08-25T09:48:47.332Z
---

Check agent status per state

```sh
watch -d "oc get agent -A -o jsonpath='{range .items[*]}{@.status.debugInfo.state}{\"\n\"}{end}' |sort | uniq --count"
```
