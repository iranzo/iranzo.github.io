---
author: Pablo Iranzo Gómez
title: Geo replication with syncthing
tags: fedora, Linux, CentOS, RHEL, backup, syncthing, FOSS
layout: post
date: 2021-06-12 21:40:34 +0200
comments: true
category: tech
description:
lang: en
---

Some years ago I started using geo replication to keep a copy of all the pictures, docs, etc

After being using BitTorrent sync and later resilio sync (even if I didn't fully liked the idea of it being not open source), I gave up. My NAS with 16 GB of ram, even if a bit older (HP N54L), seemed not to have enough memory to run it, and was constantly swapping.

Checking the list of processes pointed to the `rslsync` process as the culprit, and apparently the cause is the way it handles the files it controls.

The problem is that even one file is deleted long ago, `rslsync` does keep it in the database... and in memory. After checking with their support (as I had a family license), the workaround was to remove the folder and create a new one, which in parallel meant having to configure it again on all the systems that used for keeping a copy.

I finally decide to give [`syncthing`](https://syncthing.net/) another try after years since last evaluation.

Syncthing is now is covering some of the features I was using with `rslsync`:

- Multi-master replication
- Remote encrypted peers
- Read only peers
- Multiple folder support

In addition, it includes systemd support and it's packaged in the operating system, making it really easy to install and update (´rslsync´ was without updates for almost a year).

Only caveat, if using Debian, is to use the repository they provide as the package included in the distribution is really old, causing some issues with the remote encrypted peers.

For starting as user the command is very simple:

```sh
systemctl enable syncthing@user
systemctl starat syncthing@user
```

Once the process is started, the browser can be pointed locally at `http://127.0.0.1:8384` to start configuration:

- It is recommended to define a GUI username and password for avoiding other users with access to the system from altering the configuration. Once done, we're ready to start adding folders and systems.

One difference is that in `rslsync` having the secret for the key is enough, in `syncthing` you need to add the hosts in both ways to accept them and be able to share data.

One easing feature here is that one host can be configured as `presenter` which allows other systems to inherit the know list of hosts from the host marked as `presenter`, making it easier to do the both-ways initial introduction.

Best outcome, is that the use (or abuse) of RAM has been completely slashed what `rslsync` was using.

Currently, the only issue is that for some computers in the local network the sync was a bit slow (it even got some remote underpowered devices syncing faster than local ones), but some of the copies were fully in synced already.

The web interface is not bad, even if, for what I was used to, it's not showing as much detail about the hosts status at glance, having to open each individual folder to see how it is going, as in the general view, it shows the percentage of completion and the amount of data still missing to be synced.

Hope you like it!
