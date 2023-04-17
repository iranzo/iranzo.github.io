---
layout: post
title: Creating Jigsaw Download (JigDo) files for downloading ISO's
date: 2007-11-15T21:50:25.000Z
tags:
  - Linux
  - ISO
  - foss
lang: en
slug: Creating-Jigsaw-Download-JigDo
translationKey: Creating-Jigsaw-Download-JigDo
modified: 2023-04-17T21:51:26.975Z
categories:
  - FOSS
---

### Introduction

JigDo (`JIGsaw DOwnload`) is a small utility that can assemble a CD/DVD image from it's internal files.

For example, [Debian](http://www.debian.org/) has been using it for years for distributing the entire distribution: you downloaded a
`.jigdo` file, and then, using the utility `jigdo-lite` (package
`jigdo-file` on Debian like and RPM based[^1]. This way, you only downloaded small files from servers, preventing line failures, spreading load between several servers, etc.

Furthermore, if you already had some files (for example if you started at version X and have been downloading and keeping
all files until X.Y,
`jigdo`, can use those updated files to compare them against the `.jigdo` file and avoid downloading duplicated files...

### ¿How it works?

A JigDo download contains two parts, one, the `.jigdo` file which contains the files part of the ISO[^2] image and a template file automatically generated when creating the
`.jigdo` using `jigdo-file`.

When specified `jigdo-lite file.jigdo` will ask for previous locations (folders) that could contain required packages, and will use the URL's described in
`.jigdo` file to download any missing package and reassemble an ISO image with same MD5sum of original, but saving on bandwidth and avoiding re-downloads from network failures (just small file compared to a full DVD ISO)

### ¿How do I create a `.jigdo` and a .template file?

For example, if we download CentOS 5 DVD ISO from [mirror.centos.org](http://alufis35.uv.es/mirror.centos.org) and then mount it
`loopback` and put on a folder (for example for providing our own mirror, or
kickstart-able tree) we can do:

(Supposing that ISO is at `/var/www/CentOS/isos/` and that our exploded directory and file tree at /var/www/CentOS/tree/, we will do:

```bash
#!bash
jigdo-file mt -i /var/www/CentOS/isos/CentOS-5.0-i386-bin-DVD/CentOS-5.0-i386-bin-DVD.iso -j /var/www/CentOS/Centos5-DVD.jigdo -t /var/www/CentOS/Centos5-DVD.template —uri Centosmirrors=[http://mirror.centos.org/centos-5/5/os/i386/](http://mirror.centos.org/centos-5/5/os/i386/) /var/www/CentOS/tree/
```

After some processing and ISO<->tree verification we will have two new files.

Using a text editor we can modify our `.jigdo` file and set the URL for our source packages (for example: [http://mirror.centos.org/centos-5/5/os/i386](http://mirror.centos.org/centos-5/5/os/i386))

After that, if we provide those files to anyone, he/she could enjoy faster and better downloads of our ISO's that will get reconstructed automatically on target system

### ¿How do I get an ISO from a `.jigdo` file?

Easy:

`jigdo-lite http://SOMESERVER/PATH/file.jigdo`

JigDo will download the descriptor, search it for the template file, download it and begin creation of ISO by downloading packages not found on optional local folder (to avoid re-download of packages).

{{<enjoy>}}

[^1]: [From Dag's Repo](http://dag.wieers.com/rpm/packages/jigdo/)
[^2]: It can also be used to deliver other kind of files

Attached are the sample `.jigdo` and .template that I created for this document, right now it allows you to get a Centos 5 DVD using individual RPM files.

You can test it using `jigdo-lite`
[`http://alufis35.uv.es/deploy/Centos5-DVD.jigdo`](http://alufis35.uv.es/deploy/Centos5-DVD.jigdo)

Or: `jigdo-lite` [`http://alufis35.uv.es/deploy/CentOS51-DVD.jigdo`](http://alufis35.uv.es/deploy/CentOS51-DVD.jigdo)
