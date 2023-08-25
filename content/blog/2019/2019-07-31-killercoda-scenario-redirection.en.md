---
author: Pablo Iranzo Gómez
title: Killercoda scenario redirection
tags:
  - Killercoda
  - Katacoda
  - KubeVirt
  - citellus
  - foss
  - risu
layout: post
date: 2019-07-31 07:39:14 +0200
categories:
  - tech
lastmod: 2023-08-25T09:48:47.199Z
---

After my post about [killercoda]({{<relref "2019-06-11-killercoda-scenario.en.md">}}), I did split my initial scenarios into 'organizations'.

One of them, is in progress to get contributed upstream to [KubeVirt project killercoda](https://killercoda.com/kubevirt) (still getting some reviews to land on final repo), and the other is under [Citellus organization](https://killercoda.com/citellus).

As the goal was not to lose visits using the prior links, I contacted the team behind killercoda Support (thanks a lot Ben!!) and the requirements to get a 'redirect' in place is to:

- Remove the old folders in the killercoda-scenarios repo for your account
- Place in the root folder a file `redirect.json` containing:

```json
[
  {
    "scenario": "kubevirt",
    "targetScenario": "kubevirt",
    "targetUsername": "kubevirt"
  },
  {
    "scenario": "citellus",
    "targetScenario": "citellus",
    "targetUsername": "citellus"
  }
]
```

This file instructs to redirect 'scenario' `kubevirt` to another scenario (same name here), but on another username (`kubevirt` organization) and likewise for `citellus`.

The point here, is that old visitors from my prior post, going to either:

- [How to use Citellus](https://killercoda.com/iranzo/citellus)
- [KubeVirt](https://killercoda.com/iranzo/kubevirt)

will get instead to the updated URL for both scenarios, losing no visitors and ensuring that no 'old' copies are around.

{{<enjoy>}}
