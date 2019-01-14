---
layout: post
title: Getting started with Ansible
date: 2017-02-20 23:10:00 +0100
comments: true
tags: python, ansible, openstack, sysmgmt, foss
category: blog
description:
---
[TOC]

## Introduction
I've started to get familiar with [Ansible](http://www.ansible.com) because,
apart of getting more and more accepted for OSP-related tasks and
installation, I wanted to automate  some tasks we needed to setup some servers
for the OpenStack group I work for.

First of all, it's recommended to get latest version of ansible (tested on
RHEL7 and Fedora), but in order not to mess with the system python libraries, it's convenient to use python's virtual environments.

A virtual Environment allows to create a 'chroot'-like enviroment that might contain different library versions to the one installed with the system (but be careful as if it's not kept track as part of the usually system patching process, it might become a security concern).

## virtualenvs

For creating a virtualenv, we require the package `python-virtualenv` installed on our system and executing `virtualenv` and a target folder, for example:

~~~bash
[iranzo@iranzo ~]$ virtualenv .venv
New python executable in /home/iranzo/.venv/bin/python2
Also creating executable in /home/iranzo/.venv/bin/python
Installing setuptools, pip, wheel...done.
~~~

From this point, we've a base virtualenv installed, but as we would like to install more packages inside we'll first need to 'enter' into it:

~~~bash
. .venv/bin/activate
~~~

And from there, we can list the available/installed packages:

~~~bash
[iranzo@iranzo ~]$ pip list
DEPRECATION: The default format will switch to columns in the future. You can use --format=(legacy|columns) (or define a format=(legacy|columns) in your pip.conf under the [list] section) to disable this warning.
appdirs (1.4.0)
packaging (16.8)
pip (9.0.1)
pyparsing (2.1.10)
setuptools (34.2.0)
six (1.10.0)
wheel (0.30.0a0)
~~~

Now, all packages we install using `pip` will get installed to this folder, leaving system libraries intact.

Once we finished, to return back to system's environment, we'll execute `deactivate`.

## Pipsi

In order to simplify the management we can make use of `pipsi` which not only allows to install Python packages as we'll normally do with `pip`, but also, takes care of doing proper symlinks so the installed packages are available directly for execution.

If our distribution provides it, we can install `pipsi` on our system:

~~~bash
dnf -y install pipsi
~~~

But if not, we can use this workaround (for example, on RHEL7)

~~~bash
# Use pip to install pipsi on the system (should be minor change not affecting other software installed)
pip install pipsi
~~~

From this point, we can use pipsi to take care of installation and maintenance (can do upgrades, removal, etc) of our python packages.

For example, we can install `ansible` by executing:

~~~bash
pipsi install ansible
~~~

This might fail, as ansible, does some compiling and for doing so, it might require some development libraries on your system, have care of that to satisfy requirements for the packages.

## Prepare for ansible utilization

At this point we've the `ansible` binary available for execution as `pipsi` did take care of setting up the required symlinks, etc

Ansible uses an inventory file (can be provided on command line) so it can connect to the hosts listed there and apply `playbooks` which define the different actions to perform.

This file, for example, can consist of just a simple list of hosts to connect to like:

~~~hosts
192.168.1.1
192.168.1.2
myhostname.net
~~~

And for starting we create a simple playbook, for example a HW asset inventory:

~~~yaml
---
- hosts: all
  user: root

  tasks:
    - name: Display inventory of host
      debug:
        msg: "{{ inventory_hostname }} | {{ ansible_default_ipv4.address }} | | | {{ ansible_memtotal_mb }} | | | {{ ansible_bios_date }}"
~~~

This will act on all hosts, as user root and will run a task which prints a debug message crafted based on the contents of some of the `facts` that ansible gathers on the execution host.

To run it is quite easy:

~~~bash
[iranzo@iranzo labs]$ ansible-playbook -i myhost.net, inventory.yaml

PLAY [all] *********************************************************************

TASK [setup] *******************************************************************
ok: [myhost.net]

TASK [Display inventory of host] ***********************************************
ok: [myhost.net] => {
    "msg": "myhost.net | 192.168.1.1 | | | 14032 | | | 01/01/2011"
}

PLAY RECAP *********************************************************************
myhost.net             : ok=2    changed=0    unreachable=0    failed=0
~~~

This has connected to the target host, and returned a message with hostname, ip address, some empty fields, total memory and bios date.

This is a quite simple script, but for example, we can use `ansible` to deploy `ansible` binary on our target host using other modules available, in this case, for simplicity, we'll not be using pipsi for ansible installation.

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

    - name: Install virtualenv
      pip:
        virtualenv: "/root/infrared/.venv"
        name: pipsi

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

    - name: Install Ansible
      pip:
        virtualenv: "/root/infrared/.venv"
        name: ansible
~~~

At this point, the system should have ansible available from within the virtualenv we've created and should be avialble when executing:

~~~bash
# Activate python virtualenv
. .venv/bin/activate
# execute ansible
ansible-playbook -i hosts ansible.yaml
~~~

Have fun!
