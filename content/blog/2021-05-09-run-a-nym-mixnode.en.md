---
author: Pablo Iranzo Gómez
title: How to run a NYM mixnode
tags:
  - NYM
  - crypto
  - mixnode
  - Fedora
  - Linux
  - CentOS
  - RHEL
  - foss
layout: post
date: 2021-05-09 12:30:34 +0200
categories:
  - tech
lang: en
modified: 2022-05-04T13:03:13.546Z
---

Some time ago I've started running a NYM mixnode. `NYM` is a project that targets improving privacy by decomposing network packages from different hosts, so that origin and target cannot be traced.

You can check more about the NYM project at their site at <https://nymtech.net/>.

The project uses Open Source technology to run, and they have a nice docs with details on how to run a node at <https://nymtech.net/docs/>, and the one relevant for mixnodes at <https://nymtech.net/docs/run-nym-nodes/mixnodes/>.

But first, we need to compile it (as described in <https://nymtech.net/docs/run-nym-nodes/build-nym/>).

Those instructions are mostly adapted to Debian hosts, but it's not that different to build on RHEL, CentOS or Fedora, so let's explore how in the next steps (Note: this is based on Fedora 34 Server installation, feel free to adapt to your distribution of choice and required prerequisites on repositories, etc.)

We will need some packages to be installed for developing and compiling:

```sh
dnf -y install curl jq cargo git openssl-devel
```

Let's now clone the repository:

```sh
git clone https://github.com/nymtech/nym.git
cd nym
git checkout tags/v0.10.0
```

And let's proceed to compile the code via:

```sh
cargo build --release
```

Once it's finished, you're ready to run the mixnode.

{{<note>}}
The compiled files will be now inside the `./target/release/` folder, so you're ready to continue with the official guide at <https://nymtech.net/docs/run-nym-nodes/mixnodes/>, just remember to run `cd target/release` before, so that it will find the commands as described in the official guide.
{{</note>}}

If you want to see this guide in Asciinema check this:

[![asciicast](https://asciinema.org/a/412916.svg)](https://asciinema.org/a/412916)

Enjoy!
