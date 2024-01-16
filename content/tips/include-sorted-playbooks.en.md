---
author: Pablo Iranzo Gómez
categories:
  - tech
  - Ansible
  - Tips
title: Include Ansible playbooks sorted
tags:
  - Tips
  - Ansible
date: 2022-09-23T11:13:32.418Z
lastmod: 2024-01-16T16:29:02.226Z
---

Use sorted list for included files vs random provided by `with_fileglob`.

```yaml
- name: Include tasks
  include_tasks: "{{item}}"
  loop: "{{ query('fileglob', 'tasks/*.yaml') | sort }}"
```
