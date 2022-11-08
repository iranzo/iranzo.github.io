---
author: Pablo Iranzo Gómez
categories:
  - tech
  - Ansible
  - Tips
title: Ansible - dynamically include Jinja templates and tasks
tags:
  - Tips
  - ansible
date: 2022-09-24T11:13:32.418Z
---

For my ansible playbooks, I wanted to be able to add several new templates to be copied to target system, and additionally be able to perform some commands for them without having to specify each individual file/template to copy.

My approach:

Define for the hosts I want to find templates/playbooks define a var named `extras` for the relevant hosts:

```yaml
extras:
  - ntp
  - certificates
```

The names defined (in above example `ntp` and `certificates`) are just name of folders laying inside `tasks/templates/${folder}` that are searched and included or excluded based on `extras` values.

```yaml
---
- name: Find candidate templates
  find:
    paths:
      - "{{playbook_dir}}/tasks/templates/"
    recurse: yes
    patterns: "*.jinja"
  register: templates
  delegate_to: localhost
  when: extras is defined

- name: Copy templates from folder into path
  template:
    mode: "{{ item[1].mode }}"
    src: "{{ item[1].path }}"
    dest:
      "{{ item[1].path | replace(playbook_dir,'') | replace('/tasks/templates','') | replace('.jinja','') |replace('/' +  item[0] + '/','/')|replace('//','/')\
      \     }}"
  with_nested:
    - "{{ extras }}"
    - "{{ templates.files }}"
  loop_control:
    label:
      "{{ item[1].path | replace(playbook_dir,'') | replace('/tasks/templates','') | replace('.jinja','') |replace('/' +  item[0] + '/','/')|replace('//','/')\
      \     }}"
  when: extras is defined and templates != False and item[0] in item[1].path
  notify:
    - Restart systemd
```

And we'll do something similar for the playbooks inside those folders

```yaml
- name: Find candidate playbooks
  find:
    paths:
      - "{{playbook_dir}}/tasks/templates/"
    recurse: yes
    patterns: "*.yaml"
  register: playbooks
  delegate_to: localhost
  when: extras is defined

# Create empty array that we'll be filling
- name: Filter candidate playbooks
  set_fact:
    playbook: []
  when: extras is defined and playbooks != False

# Build an array of all the playbooks we're going to use
- name: Filter candidate playbooks
  set_fact:
    playbook: "{{ playbook + [item[1].path] }}"
  with_nested:
    - "{{ extras }}"
    - "{{ playbooks.files }}"
  loop_control:
    label: "{{ item[1].path    | replace(playbook_dir,'') | replace('/tasks/templates','') }}"
  when: extras is defined and playbooks != False and item[0] in item[1].path

- name: Load tasks from playbook
  include_tasks: "{{ item }}"
  loop: "{{ playbook }}"
  when: extras is defined and playbook != False
```

With this approach, putting files in a tree structure like:

```console
./tasks
./tasks/templates
./tasks/templates/ntp
./tasks/templates/ntp/etc
./tasks/templates/ntp/etc/ntp.conf.jinja
./tasks/templates/ntp/tasks.yaml

./tasks/templates/certificates
./tasks/templates/certificates/etc
./tasks/templates/certificates/etc/pki/
./tasks/templates/certificates/etc/pki/ca-trust/source/
./tasks/templates/certificates/etc/pki/ca-trust/source/anchors/
./tasks/templates/certificates/etc/pki/ca-trust/source/anchors/mycert.jinja
./tasks/templates/certificates/tasks.yaml
```

This will make first part of the task to copy the templates (ending in `.jinja`) to the target location, but removing the `.jinja` suffix.

For the second part, it will include the relevant `.yaml` files, and load the tasks defined within and execute as part of the playbook.
