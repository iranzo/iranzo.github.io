---
layout: post
title: Citellus: framework for detecting known issues in systems.
date: 2017-07-26 22:26:00 +0200
comments: true
tags: Python, OpenStack, sysmgmt, bash, sosreport, Citellus, FOSS
category: tech
description:
---

[TOC]

## Background

Since I became Technical Account Manager for Cloud and later as Software Maintenance Engineer for OpenStack, I became officially part of Red Hat Support.

We do usually diagnose issues based on data from the affected systems, sometimes from one system, and most of the times, from several at once.

It might be controllers nodes for OpenStack, Computes running instances, IdM, etc

In order to make it easier to grab the required information, we rely on [sosreport](https://github.com/sosreport/sos).

Sosreport has a set of plugins for grabbing required information from system, ranging from networking configuration, installed packages, running services, processes and even for some components, it can also check API, database queries, etc.

But that's all, it does data gathering, packaging in a tarball but nothing else.

In OpenStack we've already identified common issues, so we create kbases for them, ranging from covering some documentation gaps, to specific use cases or configuration options.

Many times, a missed configuration (documented) is causing headaches and can be checked with a simple checks, like TTL in `ceilometer` or `stonith` configuration on pacemaker.

Here is where Citellus comes to play.

## Citellus

The Citellus project <https://github.com/citellusorg/citellus/> created by my colleague Robin, aims on creating a set of tests that can be executed against a live system or an uncompressed sosreport tarball (it depends on the test if it applies to one or the other).

The philosophy behind is very easy:

- There's a wrapper `citellus.py` which allows to select plugins to use, or folder containing plugins, verbosity, etc and a sosreport folder to act against.
- The wrapper does check the plugins available (can be anything executable from Linux, so bash, Python, etc are there to be used)
- Then it setups some environment variables like the path to find the data and proceeds to execute the plugins against, recording the output of them.
- The plugins, on their side, determine if:
  - Plugin should be run or skipped if it's a live system, a sosreport
  - Plugin should run because of required file or package missing
  - Provide return code of:
    - **\$RC_OKAY** for **success**
    - **\$RC_FAILED** for **failure**
    - **\$RC_SKIPPED** for **skip**
    - anything else (Undetermined error)
  - Provide `stderr` with relevant messages:
    - Reason to be skipped
    - Reason for failure
    - etc
- The wrapper then sorts the output, and prints it based on settings (grouping skipped and ok by default) and detailing failures.

You can check the provided plugins on the Github repository (and hopefully also collaborate sending yours).

Our target is to keep plugins easy to write, so we can extend the plugin set as much as possible, highlighting were focus should be put at first and once typical issues are ruled out, check on the deeper analysis.

Even if we've started with OpenStack plugins (that's what we do for a living), the software is open to check against whatever is there, and we've reached to other colleagues in different speciality areas to provide more feedback or contributions to make it even more useful.

As Citellus works with sosreports it is easy to have it installed locally and test new tests.

## Writing a new test

Leading by the example is probably easier, so let's illustrate how to create a basic plugin for checking if a system is a RHV hosted engine:

```bash
#!/bin/bash

if [ "$CITELLUS_LIVE" = "0" ];  ## Checks if we're running live or not
then
        grep -q ovirt-hosted-engine-ha $CITELLUS_ROOT/installed-rpms ## checks package
        returncode=$?  #stores return code
        if [ "x$returncode" == "x0" ];
        then
            exit $RC_OKAY
        else
            echo "ovirt-hosted-engine is not installed " >&2 #Outputs info
            exit $RC_FAILED e #returns code to wrapper
        fi
else
        echo "Not running on Live system" >&2
        exit $RC_SKIPPED
fi
```

Above example is a bit `hacky`, as we count on wrapper not to output information if return code is `$RC_OKAY`, so it should have another conditional to write output or not.

## How to debug?

Easiest way to do trial-error would be to create a new folder for your plugins to test and use something like this:

```sh
[user@host mytests]$ ~/citellus/citellus.py /cases/01884438/sosreport-20170724-175510/ycrta02.rd1.rf1 ~/mytests/  [-d debug]


DEBUG:__main__:Additional parameters: ['/cases/sosreport-20170724-175510/hostname', '/home/remote/piranzo/mytests/']
DEBUG:__main__:Found plugins: ['/home/remote/piranzo/mytests/ovirt-engine.sh']
_________ .__  __         .__  .__
\_   ___ \|__|/  |_  ____ |  | |  |  __ __  ______
/    \  \/|  \   __\/ __ \|  | |  | |  |  \/  ___/
\     \___|  ||  | \  ___/|  |_|  |_|  |  /\___ \
 \______  /__||__|  \___  >____/____/____//____  >
        \/              \/                     \/
found #1 tests at /home/remote/piranzo/mytests/
mode: fs snapshot /cases/sosreport-20170724-175510/hostname
DEBUG:__main__:Running plugin: /home/remote/piranzo/mytests/ovirt-engine.sh
# /home/remote/piranzo/mytests/ovirt-engine.sh: failed
    "ovirt-hosted-engine is not installed "

DEBUG:__main__:Plugin: /home/remote/piranzo/mytests/ovirt-engine.sh, output: {'text': u'\x1b[31mfailed\x1b[0m', 'rc': 1, 'err': '\xe2\x80\x9covirt-hosted-engine is not installed \xe2\x80\x9c\n', 'out': ''}
```

That debug information comes from the python wrapper, if you need more detail inside your test, you can try `set -x` to have bash showing more information about progress.

Keep always in mind that all functionality is based on return codes and the `stderr` message to keep it simple.

Hope it's helpful for you!
Pablo

Post Datum: We've proposed this to be a talk in upcoming OSP Summit 2017 in Sydney, so if you want to see us there, don't forget to vote on <https://www.openstack.org/summit/sydney-2017/vote-for-speakers#/19095>
