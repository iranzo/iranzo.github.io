---
author: Pablo Iranzo Gómez
title: How to check if a system is virtual
tags: fedora, Linux, CentOS, RHEL, ansible
layout: post
date: 2021-05-10 14:30:34 +0200
comments: true
category: tech
description:
lang: en
---

I was improving a playbook in Ansible and wanted to find a way to find if a system was virtual or not to decide about some tunning like setting `tuned-adm profile virtual-guest` or disable the power off when the lid is closed.

After some research and try-except situations I got to this one that seemed to work (I had to tune it as one desktop machine was missing the /sys entry I was using before):

```yaml
---
- hosts: all
  user: root
  tasks:
    - name: Check if platform is Virtual
      lineinfile:
        dest: /sys/devices/virtual/dmi/id/sys_vendor
        line: "QEMU"
      check_mode: yes
      register: virtual
      failed_when: (virtual is changed) or (virtual is failed)
      ignore_errors: true

    - name: Check if platform is Physical
      set_fact:
        physical: true
        virtual: false
      when: virtual is changed

    - name: Set fact for Virtual
      set_fact:
        physical: false
        virtual: true
      when: virtual

    - name: Report system is virtual
      debug:
        msg: this is virtual
      when: virtual

    - name: Report system is physical
      debug:
        msg: This is physical
      when: physical

    - name: Get system Chassis
      shell: hostnamectl status | grep Chassis | cut -f2 -d ":" | tr -d ' '
      register: chassis
```

This playbook tasks check the sys_vendor for `QEMU` which worked for both systems on real KVM and on some other like Oracle Cloud that provided other values. It uses th `lineinfile` module that is usually used with a regexp to find a proper value and replace with the one we're interested in, like in this example I use for setting `logrotate.conf` settings:

```yaml
- name: Configure logrotate.conf
  lineinfile:
    dest: /etc/logrotate.conf
    create: true
    state: present
    regexp: "{{ item.regexp }}"
    line: "{{ item.line }}"
  with_items:
    - { regexp: "^compress", line: "compress" }
    - { regexp: "^rotate.*", line: "rotate 14" }
    - { regexp: "^daily", line: "daily" }
    - { regexp: "^weekly.*", line: "" }
    - { regexp: "^dateext.*", line: "" }
```

With the first example, we use it in `check_mode` and use it to setup `virtual` variable and later we use that to define facts for `virtual` and `physical` physical , so that we can decide to use it later in our playbooks like this:

```yaml
- name: Set tuned profile for VM's
  shell: /usr/sbin/tuned-adm profile virtual-guest
  when: virtual

- name: Configure systemd for ignoring closed lid on power
  ini_file:
    path: /etc/systemd/logind.conf
    section: Login
    option: HandleLidSwitchExternalPower
    value: ignore
  when: physical and chassis == 'laptop'

- name: Configure systemd for ignoring closed lid on Docked
  ini_file:
    path: /etc/systemd/logind.conf
    section: Login
    option: HandleLidSwitchDocked
    value: ignore
  when: physical and chassis == 'laptop'
```

Of course, this could also be extended to check if system is really a laptop or different kind of system to enable some other specific tunning, but for some initial tasks, it will do the trick.

Enjoy!
