---
author: Pablo Iranzo Gómez
categories:
  - tech
  - Ansible

  - Tips
title: Include ansible playbooks sorted
tags:
  - Tips
date: 2022-09-23T11:13:32.418Z
---

Use sorted list for included files vs random provided by `with_fileglob`.

```yaml
- name: Include cosmos tasks
  include_tasks: "{{item}}"
  loop: "{{ query('fileglob', 'tasks/*.yaml') | sort }}"
```
