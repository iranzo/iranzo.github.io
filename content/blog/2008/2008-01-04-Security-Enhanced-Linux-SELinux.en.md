---
layout: post
title: Security Enhanced Linux (SELinux)
date: 2008-01-04T18:14:03.000Z
tags:
  - Linux
  - SELinux
  - Foss
categories:
  - FOSS
lastmod: 2023-08-25T09:48:47.048Z
---

### Introduction

SELinux is an implementation of MAC (Mandatory Access Controls) over LSM (Linux Security Modules) in Linux Kernel.

SELinux, originally developed by N.S.A. (National Security Agency) allows applications to be confined by the kernel.

Inside that "confined area", much more grained than a standard `chroot` (system where basic executables are copied to another folder in order to have a small subsystem isolated from real system. The drawback is that a small subsystem could have enough utilities to reveal private information from our internal network),in which we can allow only certain operations, for example: adding information to a file, read from a directory but not writing, even just for one file in a standard directory,
etc...

#### Policies

Each policy has different applications, and restrictions to the running system. The most extended ones are:

- Targeted
- Strict
- `MLS` (Multi Level Security <http://www.cs.stthomas.edu/faculty/resmith/r/mls/index.html>

A policy is a set of "rules" that apply to any object of a system, users, software, files, network, etc. Those rules apply to security contexts, where a "context" for an object is composed of:

`user:role:type:level:category`

Based on this information, SELinux allows or denies access to any other object in system, and for doing so, it uses rules that allow process access permissions to objects.

A strict policy would require a very careful setup of system permissions, security contexts, etc, and there are several projects in order to accomplish it.

There are several sites on the Internet which provide a locked-down environment for testing (there's one to play at <http://www.coker.com.au/selinux/play.html>). Those sites make extensive usage of strict policies as well as numerous restrictions to establish user roles, limits, etc.

A system running in MLS/Strict would be difficult to use as due to security restrictions required by the policy, no windowing environment (there are some projects to achieve this,but using very simple windowing environments) would be available to avoid copying of information between windows (as this could avoid security levels).

### The [Fedora](http://fedoraproject.org/)/[Red Hat](http://www.redhat.com/)/[CentOS](http://www.centos.org/) approach

Those distributions decided to focus on just some services. Instead of using a system-wide restrictive policy, that would make system unusable, their choice was to "target" services that are subject to attacks, so, for example, there's a policy for Apache that defines exactly what files can read, what can write, what are log files, what should access from disk, etc.

This policy is named "targeted" and for services defined within, it restricts what they can do, and the rest of the system runs as
`unconfined`, as if there was no SELinux enabled at all.

This policy balances the security provided by SELinux for critical services, while keeping system usable. Services without rules continue working as on a system with SELinux disabled.

### Learning by example: Apache

#### Working with SELinux

For working with SELinux we have several tools available, most of them, are old friends:
`ls`, `ps`, `id`, etc.

Most of those tools have been expanded to use SELinux and have extra parameters, for example, in our example:

```bash
ls -lZ /usr/sbin/httpd\*
rwxr-xr-x root root system_u:object_r:httpd_exec_t /usr/sbin/httpd
rwxr-xr-x root root system_u:object_r:httpd_exec_t /usr/sbin/httpd.worker
```

The "-Z" tells `ls` to show SELinux attributes.

#### Where does system stores them

First versions of SELinux, used external files, but in order to get included into upstream Kernel, a more standard approach was required, and finally, it got implemented using system "Extended Attributes".

So, as a consequence, SELinux requires filesystems with xattr support in order to work.

In the listing before, apache is listed as system user, object role and
`httpd_exec` type.

If we do a `ps auxZ|grep httpd`

```bash
root:system_r:httpd_t apache 2923 0.0 0.4 10424 2076 ? S 00:58 0:00 /usr/sbin/httpd
```

We see that process httpd is being executed as root, system role, and httpd type.

Hey, how could that be possible? executable was `httpd_exec`, but process is
`httpd_t`...

Well, SELinux uses process transitions, in this case, `httpd_exec_t`, when executed, translates to
`httpd_t` and from now on, would be the type regulating what process can or cannot do on our system.

#### How do we start httpd daemon

We use a script at `/etc/init.d/httpd` which:

```bash
ls -lZ /etc/init.d/httpd
rwxr-xr-x root root system_u:object_r:initrc_exec_t /etc/init.d/httpd
```

Is yet another type!!!

SELinux defines another kind of "domain transition" which allows that process started by "root" or by init transition to final "httpd_t", all those rules need to be defined in a module for SELinux.

#### Are we supposed to do everything like this on our own

Not really ;-). There are several macros that automate this (for example, from
`/usr/share/selinux/devel/example.te`), we can see:

```selinux
domain_type(myapp_t)
domain_entry_file(myapp_t, myapp_exec_t)
```

That automatically setup a domain type `myapp_t`, and a transition from
`myapp_exec_t` to `myapp_t` when that executable is loaded for running it on our system.

#### How does apache loads its config files

```bash
ls -lZd /etc/httpd/
drwxr-xr-x root root system_u:object_r:httpd_config_t /etc/httpd/
```

As Apache will need to use that directory, we need to put in our custom template that permission, so we will write on our template:

```selinux
allow httpd_t httpd_config_t:dir r_dir_perms;
allow httpd_t httpd_config_t:file r_file_perms;
```

This will give permission to access `"dir"ectories` with read-only permissions as well as read-only permission to "file"s with that type.

Why do this? Well. it's a question about security... ¿why should Apache write to configuration files? SELinux allows us to confine apache in just the minimum required permissions to work without any chance to harm our system.

In a chroot environment, an attacker could get into a minimal system which could give access to our internal network, SELinux will limit this :-)

#### How do we setup correct SELinux rules to allow something blocked

Well, our installed system has a graphical SELinux troubleshooter that will pop up when there are any kind of problems with rules.

There is an command-line utility named "audit2allow" that will told us what we need to enable in order to get that problem fixed, for example:

#### What if we try to run httpd listening on port 27

```bash
audit2allow -a
#============= httpd_t ==============
allow httpd_t reserved_port_t:tcp_socket name_bind;
```

Well, this will be the "fix", but this is a "dirty" one, as will allow Apache to hook on any reserved port.

SELinux provides `semanage` that allows to define several behaviors, for example, the ports available to use by httpd_t:

```bash
semanage port -l|grep http
http_port_t tcp 80, 443, 488, 8008, 8009, 8443
```

Well, http_t uses http_port_t that enables Apache to hook on those ports, if we need to make apache to listen on 27, we'll need to execute:

`semanage port -a -t http_port_t -p tcp 27`

This will add port 27 using TCP to `http_port_t` type, and this will make Apache work ;-)

`semanage` also helps into defining clearance levels for users, and map user logins to security levels, so we can have users that get a specific clearance, that even root will not be able to access, so those files would be "private".

```bash
semanage login -l
Login Name SELinux User MLS/MCS Range __default__ user_u s0 root root SystemLow-SystemHigh
```

In this case, any user gets mapped to user_u and s0 level, root instead, gets root user and s0.c0 to s0.c255 level

We can test with policies and disabling them or not using setenforce. Set enforce allows to switch SELinux enforcing behaviour without rebooting system, so we can freely test our rules without wasting time on reboots.

#### Write a simple policy

Well, in order to write a simple policy, we need the `selinux-devel` package on our system, and then:

```bash
cp /usr/share/selinux/devel/Makefile /root
cd /root
```

Now we will need to edit a template and put something like this:

```text
policy_module(hello-world,1.0.0)
type myapp_t;
type myapp_exec_t;
domain_type(myapp_t)
domain_entry_file(myapp_t, myapp_exec_t) type myapp_log_t;
logging_log_file(myapp_log_t) type myapp_tmp_t;
files_tmp_file(myapp_tmp_t) allow myapp_t myapp_log_t:file ra_file_perms; allow myapp_t myapp_tmp_t:file manage_file_perms;
files_tmp_filetrans(myapp_t,myapp_tmp_t,file)
```

This was the sample template placed at
`/usr/share/selinux/devel/example.te`, using it together with `example.fc`:

```bash
/usr/sbin/myapp — gen_context(system_u:object_r:myapp_exec_t,s0)
```

Will provide a complete policy for our app:

This defines that `/usr/sbin/myapp` will have the context
`system_u:object_r:myapp_exec_t` and s0. Depending on the policy we're running, the
`gen_context` will create adequate context for that file.

In order to get it loaded, we just need to do `make load`, and module will be compiled (they use m4 macro language), and then
loaded.

#### How do we verify that a module has been loaded

With `semodule -l` all loaded modules will be shown, remember that some policies allow booleans to enable or disable certain aspects of them. We can check all defined booleans for currently loaded modules with `getsebool -a` and we can set them with `setsebool` , using "-P" in order to set that value as default after reboots.

We can switch a value using `togglesebool` value but this will not set it as default for next reboot.

I hope this can help you as a small introduction to SELinux and it's features :)

PD: News and updates about SELinux at [SELinux News](http://www.selinuxnews.org/wp/)
{{<enjoy>}}
