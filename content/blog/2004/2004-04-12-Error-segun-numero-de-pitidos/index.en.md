---
layout: post
title: Error depending of number of beeps in BIOS
date: 2004-04-12T09:54:00.000Z
tags:
  - hardware
  - BIOS
  - error
lang: en
modified: 2023-03-23T10:54:59.533Z
categories:
  - blog
---

BIOS (Basic Input Output System) from PC's report errors in the hardware at boot with a code of beeps, that can help diagnose the issue in case there's no image being displayed.

Error code reported by BIOS during POST (Power On Self Test):

## Fatal errors

| # of beeps | Meaning                      |
| ---------- | ---------------------------- |
| 1          | DRAM refresh error           |
| 2          | 640Kb base RAM error         |
| 4          | system timer error           |
| 5          | CPU error                    |
| 6          | Keyboard Gate A20 error      |
| 7          | Virtual mode exception error |
| 9          | BIOS-ROM checksum error      |

## Non-Fatal errors

| # of beeps | Meaning                                            |
| ---------- | -------------------------------------------------- |
| 3          | Memory test failure conventional and extended      |
| 8          | Monitor error with tracing vertical and horizontal |
