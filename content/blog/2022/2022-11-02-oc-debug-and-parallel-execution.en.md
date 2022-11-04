---
author: Pablo Iranzo Gómez
tags:
  - tech
  - OpenShift
  - Tips
  - Troubleshooting
  - RISU
  - Citellus
  - FOSS
title: OpenShift's oc debug and parallel execution
categories:
  - tech
date: 2022-10-03T14:13:32.418Z
---

A colleague reported some issues in the OpenShift troubleshooting and diagnosis scripts at [OpenShift-checks](https://github.com/RHsyseng/openshift-checks/).

Some time ago I did contribute some changes to use functions and allow using the [RISU](https://github.com/risuorg/risu) wrapper to the scripts, helping consuming the results via RISU's HTML interface.

As my colleague reported, for some plugins, the output of the command was not shown in the HTML Interface.

After some investigation, it was found that parallel execution for the plugins was causing no output to be shown, but when filtering to individual ones via `risu -i XXXXXXX/plugin -l` it was working fine... the problem was not the check itself, as both of them worked fine when executed individually but failed when executing them together.

As a way forward, a small patch that allowed to limit the number of concurrent plugin executions was added to Risu, and effectively, when limiting to one plugin at a time, both of them returned results.

Further investigation found the reason... many checks in `openshift-checks` do use `oc debug` command to launch commands interactively in the hosts, and as each plugin does their own set of checks vs grabbing all the data and then doing processing, this was causing issues. In the case of the included wrapper, it still could cause issues as some parallelization was included, but when used together with `risu.py` the problem became more apparent.

Finally the workaround used is a small function added that checks if there's a running `oc debug` check, and if so, waiting a random delay of seconds, which effectively doesn't affect the execution, but allows to use the plugins normally:

```sh
ocdebugorwait() {
  instances=$(pgrep -f 'oc debug' | wc -l)
  while [ "${instances}" != "0" ]; do
    # Waiting for oc debug to not be anymore
    sleep $(($RANDOM % 10))
    instances=$(pgrep -f 'oc debug' | wc -l)
  done
```

When invoked in the scripts with `ocdebugorwait` the code enters this loop before attempting the `oc debug` command.

With this patch, the reported output is obtained, and of course, properly shown in the HTML interface while doing troubleshooting with Risu.
