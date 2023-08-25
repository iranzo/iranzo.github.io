---
author: Pablo Iranzo Gómez
categories:
  - tech
  - Tips
title: Automating SSH keys loading for Ansible usage
tags:
  - Tips
  - ssh
  - ansible
date: 2023-03-02T16:40:32.418Z
lastmod: 2023-08-25T09:48:46.664Z
---

For using Ansible it's required to have a working set of ssh-keys already deployed.

If you get a set of systems that have not been provisioned by you and are missing the SSH keys, having it fixed might take a while if doing it manually. Good news is that you can use a script in `expect` to cover this part:

```expect
#!/usr/bin/expect -f
# set Variables
set password [lrange $argv 0 0]
set ipaddr [lrange $argv 1 1]

# now connect to remote system
spawn ssh-copy-id root@$ipaddr
match_max 100000

# Check for initial connection (add key of host)
set timeout 5
expect "yes/no" { send -- "yes\r" }

# Check for password prmpt
set timeout 120
# Look for passwod prompt
expect "password:" { send -- "$password\r" }
# send blank line (\r) to come back
send -- "\n"
expect eof
```

This script, when used like:

```bash
sshkeyscopy letmein mynewhost
```

Will connect to the specified host, using `letmein` as password to authenticate, and use the `ssh-copy-id` command to load your ssh keys.

To further automate, we can create an ansible playbook like this:

```yaml
---
- hosts: all
  user: root

  vars:
    rootpassword: letmein

  tasks:
    - name: Copy ssh keys
      shell: sshkeyscopy {{ rootpassword }} {{ item }}
      with_items: "{{ groups['all'] }}"
      delegate_to: localhost
```

Using this playbook, we will delegate to `localhost` the connection to all of the specified hosts in the inventory and use this `expect` script to load the keys.

Once it's done, we can test that we can ssh into the hosts without password being prompted.
