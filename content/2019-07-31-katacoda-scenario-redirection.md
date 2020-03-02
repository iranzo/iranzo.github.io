---
author: Pablo Iranzo Gómez
title: Katacoda scenario redirection
tags: katacoda, kubevirt, citellus, foss
layout: post
date: 2019-07-31 07:39:14 +0200
comments: true
category: tech
description:
---

After my post about [Katacoda]({filename}2019-06-11-katacoda-scenario.md), I did separated my initial scenarios into 'organizations'.

One of them, is in progress to get contributed upstream to [KubeVirt project Katacoda](https://katacoda.com/kubevirt) (still getting some reviews to land on final repo), and the other is under [Citellus organization](https://katacoda.com/citellus).

As the goal was not to lose visits using the prior links, I contacted the team behind Katacoda Support (thanks a lot Ben!!) and the requirements to get a 'redirect' in place is to:

- Remove the old folders in the katacoda-scenarios repo for your account
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

- [How to use Citellus](https://www.katacoda.com/iranzo/scenarios/citellus)
- [Kubevirt](https://www.katacoda.com/iranzo/scenarios/kubevirt)

will get instead to the updated URL for both scenarios, losing no visitors and ensuring that no 'old' copies are around.

Enjoy!
