---
author: Pablo Iranzo Gómez
tags:
  - tech
  - Tips
  - Ansible
  - FOSS
title: Automate code build and deployment with ansible
categories:
  - tech
date: 2022-11-09T07:00:46.350Z
lastmod: 2023-08-25T09:45:44.522Z
---

Let's say that we want to keep our system updated with some code which is not distributed as a regular package, but as a code in a repository (which unfortunately, it's a pretty common situation).

As a part of the ansible playbooks used for the hosts, I can add a snippet like this:

```yaml
gitrepos:
  - {
      url: "https://github.com/myrepo/repo.git",
      tag: "tagtocheckout",
      folder: "/root/path-for-check-out",
      chdir: "subdir to enter",
      build: "make build",
      exec: "build/mybuiltbinary",
    }
```

With this definition in the host inventory, we can then in our playbook to perform several steps:

1. First Checkout the repository, note that we loop over `gitrepos` variable and use the items defined. We also set `ignore_errors` to ensure our playbook run doesn't halt in case of any mistake here.

   Also, we register the output in the `repos` variable for later processing (we'll see why later).

   ```yaml
   - name: Checkout git repos at specific versions
       git:
       repo: "{{ item.url }}"
       dest: "{{ item.folder }}"
       version: "{{ item.tag}}"
       with_items: "{{ gitrepos }}"
       ignore_errors: true
       register: repos
       when: gitrepos != False
   ```

1. Next, as we'll be building the binary from the repo, we want to make sure that previous built ones are absent, so that we can force rebuilding it.

   Note that were appending the `chdir` path if it's defined... it's a special use case, because some repositories, contain different set of code in sub-folders instead of being on different repositories, so this helps in this situation. Of course, we're doing this, only when a new release has been checked out in prior step (`repos.changed`).

   ```yaml
   - name: Remove previous binary if tag changed to get it recompiled
       file:
       name: "{{ item.folder }}/{% if item.chdir is defined %}/{{item.chdir}}{% endif %}{{ item.exec }}"
       state: absent
       when: repos.changed
       with_items: "{{ gitrepos }}"
   ```

1. Now we're ready to build the code, as we've defined also the `chdir` we get into the relevant folder and run the `build` command to generate the binary... as a result it must create a binary in `item.exec` so that we can validate it worked or not and of course, only if we've defined a build command.
   ```yaml
   - name: Build git repos
       shell:
       cmd: "{{ item.build }}"
       chdir: "{{ item.folder }}{% if item.chdir is defined %}/{{item.chdir}}{% endif %}"
       creates: "{{ item.exec }}"
       with_items: "{{ gitrepos }}"
       ignore_errors: true
       when: gitrepos != False and item.build is defined and item.build != False
   ```
1. Last step... as we got the binary built, we might want to copy it to a folder into our path so that it can be used, in this example, to the `go/bin` folder:
   ```yaml
   - name: copy built command
       copy:
       remote_src: yes
       dest: "/root/go/bin/"
       src: "{{item.folder}}{% if item.chdir is defined %}/{{item.chdir}}{% endif %}/{{ item.exec }}"
       mode: "0755"
       with_items: "{{ gitrepos }}"
       ignore_errors: true
       when: gitrepos != False and item.build is defined and item.build != False
   ```

By defining several repo stanzas, we can automate the process... and this is just the first step, as we can also define the `checkout` tag by first querying the repo latest release (if we want to live on the bleeding edge), so this whole process keeps your system using latest tools available, and built from source.

{{<enjoy>}}
