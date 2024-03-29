---
layout: post
title: Magui for analysis of issues across several hosts.
date: 2017-07-31 12:45:00 +0200
tags:
  - Python
  - OpenStack
  - sysmgmt
  - bash
  - sosreport
  - Citellus
  - Magui
  - FOSS
categories:
  - tech
  - risu
lastmod: 2023-08-25T09:48:46.883Z
---

## Background

[Citellus]({{<relref "2017-07-26-Citellus-framework-for-detecting-known-issues.en.md">}}) allows to check a sosreport against known problems identified on the provided tests.

This approach is easy to implement and easy to test but has limitations when a problem can span across several hosts and only the problem reveals itself when a general analysis is performed.

Magui tries to solve that by running the analysis functions inside citellus across a set of sosreports, unifying the data obtained per citellus plugin.

At the moment, Magui just does the grouping of the data and visualization, for example, give it a try with the `seqno` plugin of citellus to report the sequence number in
Galera database:

```
[user@host folder]$ magui.py * -f seqno # (filtering for ‘seqno’ plugins).
{'/home/remote/piranzo/citellus/citellus/plugins/openstack/mysql/seqno.sh': {'ctrl0.localdomain': {'err': '08a94e67-bae0-11e6-8239-9a6188749d23:36117633\n',
                                                                                                   'out': '',
                                                                                                   'rc': 0},
                                                                             'ctrl1.localdomain': {'err': '08a94e67-bae0-11e6-8239-9a6188749d23:36117633\n',
                                                                                                   'out': '',
                                                                                                   'rc': 0},
                                                                             'ctrl2.localdomain': {'err': '08a94e67-bae0-11e6-8239-9a6188749d23:36117633\n',
                                                                                                   'out': '',
                                                                                                   'rc': 0}}}

```

Here, we can see that the sequence number on the logs is the same for the hosts.

The goal, once this has been discussed and determined, is to write plugins that get the raw data from citellus and applies logic on top by parsing the raw data obtained by the increasing number of citellus plugins and is able to detect issues like, for example:

- Galera `seqno`
- cluster status
- NTP synchronization across nodes
- etc

{{<enjoy>}}

PD: We've proposed this to be a talk in upcoming OSP Summit 2017 in Sydney, so if you want to see us there, don't forget to vote on <https://www.openstack.org/summit/sydney-2017/vote-for-speakers#/19095>
