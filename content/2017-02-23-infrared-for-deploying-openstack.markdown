---
layout: post
title: InfraRed for deploying OpenStack
date: 2017-02-23 23:27:00 +0100
comments: true
tags: python, ansible, openstack, sysmgmt, InfraRed, foss
category: blog
description:
---
**Table of contents**
<!-- TOC depthFrom:1 insertAnchor:true orderedList:true -->

1. [Why InfraRed?](#why-infrared)
2. [Setup of InfraRed-running host](#setup-of-infrared-running-host)
3. [Remote host setup](#remote-host-setup)
4. [NOTES](#notes)
5. [Error reporting](#error-reporting)
6. [RFE/BUGS](#rfebugs)
7. [Using Ansible to deploy InfraRed](#using-ansible-to-deploy-infrared)
8. [Deploy environment examples](#deploy-environment-examples)
    1. [Common requirements](#common-requirements)
9. [Cleanup](#cleanup)
    1. [OSP 9 (3 + 2)](#osp-9-3--2)
        1. [Define version to use](#define-version-to-use)
    2. [OSP 8 (3+2)](#osp-8-32)
    3. [OSP 10 (3+2)](#osp-10-32)
    4. [OSP 7 (3+2+3)](#osp-7-323)
10. [Wrapping-up](#wrapping-up)

<!-- /TOC -->

[InfraRed](https://github.com/redhat-openstack/infrared/) is tool that allows to install/provision OpenStack. You can find the documentation for the project at <http://infrared.readthedocs.io>.

Also, developers and users are online in FreeNode at #infrared channel.

<a id="markdown-why-infrared" name="why-infrared"></a>
## Why InfraRed?

Deploying OSP with OSP-d (TripleO) requires several setup steps for preparation, deployment, etc. InfraRed simplifies them by automating with ansible most of those steps and configuration.

- It allows to deploy several OSP versions
- Allows to ease connection to installed vm roles (Ceph, Computes, Controllers, Undercloud)
- Allows to define working environments so one InfraRed-running host can be used to manage different environments
- and much more...

<a id="markdown-setup-of-infrared-running-host" name="setup-of-infrared-running-host"></a>
## Setup of InfraRed-running host

Setting InfraRed is quite easy, at the moment the version 2 (branch on github) is working pretty well.

We'll start with:

- Clone GIT repo: `git clone https://github.com/redhat-openstack/infrared.git`
- Create a virtual ENV so we can proceed with installation, later we'll need to source it before each use.    `cd infrared ;  virtualenv .venv && source .venv/bin/activate`
- Proceed with upgrade of pip and setuptools (required) and installation of InfraRed
    - `pip install --upgrade pip`
    - `pip install --upgrade setuptools`
    - `pip install .`

<a id="markdown-remote-host-setup" name="remote-host-setup"></a>
## Remote host setup

Once done, we need to setup the requirements on the host we'll use to virtualize, this includes, having the system registered against a repository providing required packages.

- Register RHEL7 and update:
    - `subscription-manager register` (provide your credentials)
    - `subscription-manager attach --pool=` (check pool number first)
    - `subscription-manager repos --disable=*`
    - `for canal in rhel-7-server-extras-rpms rhel-7-server-fastrack-rpms rhel-7-server-optional-fastrack-rpms rhel-7-server-optional-rpms rhel-7-server-rh-common-rpms rhel-7-server-rhn-tools-rpms rhel-7-server-rpms rhel-7-server-supplementary-rpms rhel-ha-for-rhel-7-server-rpms;do subscription-manager repos --enable=$canal; done`

<a id="markdown-notes" name="notes"></a>
## NOTES

- OSP7 did not contain RPM packaged version of images, a repo with the images needs to be defined like:
    - `time infrared tripleo-undercloud --version $VERSION --images-task import --images-url $REPO_URL`
    - NOTE: --images-task `import` and `--images-url`
- Ceph failed to install unless `--storage-backend ceph` was provided (open bug for that)

<a id="markdown-error-reporting" name="error-reporting"></a>
## Error reporting

- IRC or github

<a id="markdown-rfebugs" name="rfebugs"></a>
## RFE/BUGS

Some bugs/RFE on the way to get implemented some day:

- Allow use of localhost to launch installation against local host
- Multi env creation, so several osp-d versions are deployed on the same hypervisor but one launched
- Automatically add `--storage-backend ceph` when ceph nodes defined

<a id="markdown-using-ansible-to-deploy-infrared" name="using-ansible-to-deploy-infrared"></a>
## Using Ansible to deploy InfraRed

This is something that I began testing to automate the basic setup, still is needed to decide version to use, and do deployment of infrastructure vm's but does some automation for setting up the hypervisors.

~~~yaml
---
- hosts: all
  user: root

  tasks:
    - name: Install git
      yum:
        name:
          - "git"
          - "python-virtualenv"
          - "openssl-devel"
        state: latest

    - name: "Checkout InfraRed to /root/infrared folder"
      git:
        repo: https://github.com/redhat-openstack/infrared.git
        dest: /root/infrared

    - name: Initialize virtualenv
      pip:
        virtualenv: "/root/infrared/.venv"
        name: setuptools, pip

    - name: Upgrade virtualenv pip
      pip:
        virtualenv: "/root/infrared/.venv"
        name: pip
        extra_args: --upgrade

    - name: Upgrade virtualenv setuptools
      pip:
        virtualenv: "/root/infrared/.venv"
        name: setuptools
        extra_args: --upgrade

    - name: Install InfraRed
      pip:
        virtualenv: "/root/infrared/.venv"
        name: file:///root/infrared/.

~~~

This playbook will do checkout of git repo, setup extra pip commands to upgrade virtualenv's deployed pip and setuptools, etc.

<a id="markdown-deploy-environment-examples" name="deploy-environment-examples"></a>
## Deploy environment examples

This will show the commands that might be used to deploy some environments and some sample timings on a 64Gb RAM host.

<a id="markdown-common-requirements" name="common-requirements"></a>
### Common requirements

~~~bash
export HOST=myserver.com
export HOST_KEY=~/.ssh/id_rsa
export ANSIBLE_LOG_PATH=deploy.log
~~~

<a id="markdown-cleanup" name="cleanup"></a>
## Cleanup

~~~bash
time infrared virsh --cleanup True --host-address $HOST --host-key $HOST_KEY
~~~

<a id="markdown-osp-9-3--2" name="osp-9-3--2"></a>
### OSP 9 (3 + 2)

<a id="markdown-define-version-to-use" name="define-version-to-use"></a>
#### Define version to use

~~~bash
export VERSION=9

time infrared virsh --host-address $HOST --host-key $HOST_KEY --topology-nodes "undercloud:1,controller:3,compute:2"

real    11m19.665s
user    3m7.013s
sys     1m27.941s

time infrared tripleo-undercloud --version $VERSION --images-task rpm

real    48m8.742s
user    10m35.800s
sys     5m23.126s

time infrared tripleo-overcloud --deployment-files virt --version 9 --introspect yes --tagging yes --post yes

real    43m44.424s
user    9m36.592s
sys     4m39.188s
~~~

<a id="markdown-osp-8-32" name="osp-8-32"></a>
### OSP 8 (3+2)

~~~bash
export VERSION=8

time infrared virsh --host-address $HOST --host-key $HOST_KEY --topology-nodes "undercloud:1,controller:3,compute:2"

real    11m29.478s
user    3m10.174s
sys     1m28.276s

time infrared tripleo-undercloud --version $VERSION --images-task rpm

real    40m47.387s
user    9m14.151s
sys     4m24.820s

time infrared tripleo-overcloud --deployment-files virt --version $VERSION --introspect yes --tagging yes --post yes

real    42m57.315s
user    9m2.412s
sys     4m25.840s
~~~

<a id="markdown-osp-10-32" name="osp-10-32"></a>
### OSP 10 (3+2)

~~~bash
export VERSION=10

time infrared virsh --host-address $HOST --host-key $HOST_KEY --topology-nodes "undercloud:1,controller:3,compute:2"

real    10m54.710s
user    2m42.761s
sys     1m12.844s

time infrared tripleo-undercloud --version $VERSION --images-task rpm

real    43m10.474s
user    8m34.905s
sys     4m3.732s

time infrared tripleo-overcloud --deployment-files virt --version $VERSION --introspect yes --tagging yes --post yes

real    54m1.111s
user    11m55.808s
sys     6m1.023s
~~~

<a id="markdown-osp-7-323" name="osp-7-323"></a>
### OSP 7 (3+2+3)

~~~bash
export VERSION=7

time infrared virsh --host-address $HOST --host-key $HOST_KEY --topology-nodes "undercloud:1,controller:3,compute:2,ceph:3"

real    13m46.205s
user    3m46.753s
sys     1m47.422s

time infrared tripleo-undercloud --version $VERSION --images-task import    --images-url $URLTOIMAGES

real    43m14.471s
user    9m45.479s
sys     4m53.126s

time infrared tripleo-overcloud --deployment-files virt --version $VERSION --introspect yes --tagging yes --post yes     --storage-backend ceph

real    86m47.471s
user    20m2.582s
sys     9m42.577s
~~~

<a id="markdown-wrapping-up" name="wrapping-up"></a>
## Wrapping-up

Please do refer to the InfraRed documentation to get deeper in its possibilities and if interested, consider contributing!
