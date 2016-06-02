---
layout: post
title: "RHEV-M with nested VM for OSP"
date: 2015-07-17 18:34:17 +0200
comments: true
tags: linux, openstack, rhev, ovirt, vdsm, hook, nestedvt
description: 
---

Since some time ago, I've been mostly dealing with OpenStack, requiring different releases to test for different tests, etc.

Virtualization, as provided by KVM requires some CPU flags to get accelerated operations, vmx and svm depending on your processor architecture, but, of course, this is only provided on bare-metal.

In order to get more flexibility at the expense of performance, `nestedvt` allows to expose those flags to the VM's running at the hypervisor so you can run another level of VM's inside those VM's (this starts to sound like the movie [Inception](http://www.imdb.com/title/tt1375666/)).

The problem, so far is that this required changes on the kernel and drivers to make it work, and was lacking lot of stability, so this is something ***NOT SUPPORTED FOR PRODUCTION USE*** but which makes perfect sense for demo environments, labs, etc, allowing you to maximize the use of your hardware for better flexibility but at the cost of performance.

As I was using RHEV for managing my home-lab I hit the first issue, my hypervisors (HP Proliant G7 N54L) where using RHEL-6 as operating system, and the support for nested was not very good, but luckily, RHEV-M 3.5 includes support for hypervisors running on RHEL-7, enabling to use latest features included in kernel, networking stack, etc.

First step, was to redeploy the servers, wasn't that hard, but required some extra steps as I had another unsupported approach (servers were sharing local storage over NFS for providing Storage Domains to environment, ***HIGHLY UNSUPPORTED***), so I moved them from NFS to iSCSI provided by an external server and with the help of the kickstart I use for other systems, I started the process.

Once the two servers were migrated, the last one, finished moving VM's from NFS to iSCSI and needed to be put on maintenance and enable the other two (as a safety measure, RHEL-6 and RHEL-7 hosts cannot coexist on the same cluster in RHEV).

From here, just needed to enable NestedVT on the environment.

`NestedVT` 'just' requires to expose the `svm` or `vmx` flag to the VM running directly from the bare-metal host, and we need to do that for every VM we start. On normal system with libvirt, we can just edit the XML for the VM definition and define the CPU like this:

~~~
#!xml 
<cpu mode='custom' match='exact'>
    <model fallback='allow'>Opteron_G3</model>
    <feature policy='require' name='svm'/>
</cpu>
~~~

For RHEV, however, we don't have an XML we can edit, as it is created dynamically with the contents of the database for the VM (disks, NICS, name, etc), but we've the [VDSM-Hooks](http://www.ovirt.org/VDSM-Hooks) mechanism for doing this.

Hooks in vdsm are a powerful and dangerous tool, as they can modify in-flight the XML used to create the VM, and allow lot of features to be implemented.

In the past, for example, those hooks could be used to provide DirectLUN support to RHEV, or fixed BIOS Serial Number for VM's where the product was still lacking the official feature, and in this case, we'll use them to provide the CPU flags we need.

As you can imagine, this is something that has lot of interested people behind, and we can find upstream a repository with [VDSM-Hooks](http://resources.ovirt.org/pub/ovirt-3.5/rpm/el7Server/noarch/).

In this case, the one that we're needing is 'nestedvt', so we can proceed to install it on our hosts like:

~~~
#!bash 
wget http://mirrors.ibiblio.org/ovirt/pub/ovirt-3.4/rpm/el7/noarch/vdsm-hook-nestedvt-4.14.17-0.el7.noarch.rpm
rpm -Uvh vdsm-hook-nestedvt-4.14.17-0.el7.noarch.rpm
~~~

You'll need to put a host in maintenance and activate for VDSM to refresh the hooks installed and start new VM so we have the hook injecting the XML.

After it boots, `egrep 'svm|vmx' /proc/pcuinfo` should show the flags there.

But wait... 

RHEV also includes a security feature that makes it impossible for a VM to spy on the communications meant to other VM's that makes it impossible to simulate other MAC's within it, and this is performed via libvirt filters on the interfaces.

To come to our rescue, another hook comes to play in, this time `macspoof` which allows to disable this security measure for a VM so it can execute virtualization within.

First, let's repeat the procedure and install the hook on all of our hypervisors:

~~~
#!bash 
wget http://mirrors.ibiblio.org/ovirt/pub/ovirt-3.4/rpm/el7/noarch/vdsm-hook-macspoof-4.14.17-0.el7.noarch.rpm
rpm -Uvh vdsm-hook-macspoof-4.14.17-0.el7.noarch.rpm
~~~

This will enable the hook in the system, but we also need to make the RHEV-M Engine aware of it, so we need to define a new Custom Property for VM's:

~~~
#!bash 
engine-config -s "UserDefinedVMProperties=macspoof=(true|false)"
~~~

This will ask us for the compatibility version (we'll choose 3.5) and enable a new true/false property for VM's that require this security measure lifted. We're doing of course this approach instead of disabling it for everyone to limit it's use to just the VM's needing it, not losing all the benefits on security provided.

As a side note, macspoof plugin is available in official repositories for RHEL7 hypervisor, so you can use this instead of oVirt's repo one.

Now when we create a new VM, for example to use with OpenStack, we can go to custom properties for this vm, select 'macspoof' and set a value of 'true' and once the VM is started will be able to see the processor extensions for virtualization and at the same time, the VM's created within, will be able to communicate with the outside world.

Enjoy!
