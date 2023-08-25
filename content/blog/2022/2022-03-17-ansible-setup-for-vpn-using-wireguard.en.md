---
author: Pablo Iranzo Gómez
title: Ansible setup for VPN using WireGuard
tags:
  - VPN
  - WireGuard
  - Ansible
  - Linux
  - automation
layout: post
date: 2022-03-17T20:32:50.391Z
categories:
  - Ansible
description: Learn on how to setup a VPN using WireGuard using Ansible
lang: en
lastmod: 2023-08-25T09:45:44.498Z
---

Setting up WireGuard is not a difficult process but I wanted to automate it among hosts by using a simple playbook that can be executed against the hosts and get it configured and deployed in a simple way.

I also wanted to require the minimum possible number of values in the inventory, so tried to automate lot of the information required, leaving in the end only some required values:

```yaml
wireguard: True
wgrole: 'master' or 'something else'
wgport: port number to use
```

The first step was to create the private and public key once the `wireguard` package is installed.

This was more or less easy, just run and store the output in the folder for WireGuard.

```sh
# Create private key
wg genkey | tee privatekey

# Create public key
wg  pubkey < privatekey | tee publickey
```

Later, I could set via Ansible's `set_fact`:

```yaml
- name: Set WireGuard keys
  set_fact:
    wgprivatekey: "{{ lookup('file', 'privatekey') }}"
    wgpublickey: "{{ lookup('file', 'publickey') }}"
```

But I got to the first problem... the facts are set by the host running the playbook, and for setting master/client connection I need to use the master's public key available on the client, and the client's public key on the master.

As the fact was setup at execution, other hosts couldn't check them via `hostvars`...

To solve this issue I went by creating a custom `fact` that is copied over the hosts, and that causes the host to refresh if something has been copied, this made the fact available in the execution:

Facts for private key:

```sh
#!/bin/bash
echo "{\"wgprivkey\" : \"$(cat /etc/wireguard/privatekey)\"}"
```

Fact for public key:

```sh
#!/bin/bash
echo "{\"wgpubkey\" : \"$(cat /etc/wireguard/publickey)\"}"
```

Note that both, provide output in a JSON compatible format.

We now need to copy the facts to the hosts and refresh the data if needed:

```yaml
- name: Create directory for ansible custom facts
  file:
    state: directory
    recurse: yes
    path: /etc/ansible/facts.d
  register: facts_dir_created

- name: Copy custom facts
  copy:
    src: "{{ item }}"
    dest: /etc/ansible/facts.d/
    owner: root
    group: root
    mode: 0755
  with_fileglob:
    - "facts/*.fact"
  register: facts_copied

- name: "Re-run setup to use custom facts"
  setup: ~
  when: facts_copied.changed
```

Now... all hosts have the facts for private and public key so that can be used... but we need to actually create WireGuard configuration file for it... but wait... we need to know which host is the `master` that will receive all connections from the clients.

So, let's detect the master by the `wgrole` value:

```yaml
- name: Set wireguard master server host
  set_fact:
    wgmaster: "{{ item }}"
  with_items: "{{ groups.all }}"
  when: hostvars[item].wgrole is defined and hostvars[item].wgrole == 'master' and wireguard == True
```

Above task will loop across all hosts, check for the `wgrole` defined and equal to `master` (with `wireguard` enabled), and set the `wgmaster` fact to the hostname.

We will also need to calculate the IP to use for the master and the client in a private range... so let's just get the number of item in the list for this:

```yaml
- name: Calculate IP for host
  set_fact:
    wgip: "10.0.0.{{ lookup('ansible.utils.index_of', groups.all, 'eq', inventory_hostname) }}"
```

Now, each host will get a 'fact' `wgip` with the content similar to `10.0.0.1` that we can use to connect them.

So... we should have all the information to create the configuration file for each client host:

```yaml
- name: Create configuration file for client
  copy:
    dest: "/etc/wireguard/wg0.conf"
    mode: 0644
    content: |
      [Interface]
      ListenPort = {{ wgport }}
      PrivateKey = {{ ansible_local.wgprivkey.wgprivkey }}

      [Peer]
      PublicKey = {{ hostvars[wgmaster].ansible_local.wgpubkey.wgpubkey }}
      AllowedIPs = {{ hostvars[wgmaster].wgip }}/32
      Endpoint = {{ hostvars[wgmaster].inventory_hostname }}:{{ hostvars[wgmaster].wgport }}
  when: wireguard == True and wgrole is defined and wgrole != 'master'
```

In above example, check that we use `hostvars` with the `wgmaster` value we obtained, in order to fill-in the values for the master, and make use of `ansible_local` to grab the values that our custom facts generated.

So far, it has been more or less easy... the problem is that in the master, we need to build a base section (`[Interface`]) and then, ad the client section (`[Peer]`) with the client's public key and the IP of the client.

Next, let's check the one for the master:

```yaml
- name: Create configuration file for master
  copy:
    dest: "/etc/wireguard/wg0.conf"
    mode: 0644
    content: |
      [Interface]
      ListenPort = {{ wgport }}
      PrivateKey = {{ hostvars[wgmaster].ansible_local.wgprivkey.wgprivkey }}

      {%- for item in hostvars -%}
      {% if hostvars[item].wgrole is defined and hostvars[item].wgrole != 'master' %}

      [Peer]
      PublicKey = {{ hostvars[item].ansible_local.wgpubkey.wgpubkey }}
      AllowedIPs = {{ hostvars[item].wgip }} /32
      Endpoint = {{ hostvars[item].inventory_hostname }}:{{ hostvars[item].wgport }}


      {% endif %}
      {%- endfor -%}

  when: wireguard == True and wgrole is defined and wgrole == 'master' and item == wgmaster
  with_inventory_hostnames:
    - all
```

More or less, the logic should be clear... we iterate over all the hosts with `wireguard: True` and `wgrole` not master to add their section.... and this only runs on the `master` host, a the clients would have get the previous task instead.

Of course, extra tasks would be needed for:

- Bringing service up
- Open firewall ports
- etc.

Hope you liked it!, it got me busy for some time until all pieces matched together :)
{{<enjoy>}}
