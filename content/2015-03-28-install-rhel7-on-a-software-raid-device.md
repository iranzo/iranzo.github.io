---
layout: post
title: Install RHEL7/Centos/Fedora on a software raid device
date: 2015-03-28 18:46:42 +0100
comments: true
tags: linux, centos, Fedora, rhel, foss
description:
---
[TOC]

Installing Linux on a RAID has lot of advantages, from using RAID1 to enjoy protection against drive failures or RAID0 to combine the size of several drives to create bigger space for files with all the smaller disks we have.

There are several [RAID](http://en.wikipedia.org/wiki/RAID) level definitions and may have different uses depending on our needs and hardware availability.

For this, I focused on using raid1 for the system disks (for greater redundancy/protection against failures) and raid0 (for combining several disks to make bigger space available for non important data)..

## Why or why not use a RAID via software

### Pros

- There's no propietary data on the disks that could require this specific controller in case the hardware fails.
- Can be performed on any system, disk combination, etc

### Cons

- The use of dedicated HW RAID cards allows to offload the CPU intensive tasks for raid calculation, etc to the dedicated processor, freeing internal CPU for system/user usage.
- Dedicated cards may have fancier features that require no support from the operating system as are all implemented by the card itself and presented to the OS as a standard drive.

## Performing the setup

As I was installing on a HP Microserver G8 recently, I had to first disable the advanced mode for the included controller, so it behaved like a standard SATA one, once done, I was able to boot from my OS image (in this case EL7 iso).

Once the ISO is booted in `rescue` mode, I could  switch to the second console with `ALT-F2` so I could start executing commands on the shell.

First step is to setup partitioning, in this case I did two partitions, first one for holding `/boot` and the second one for setting up the *LVM physical volume* where the other `Logical Volumes` will be defined later.

I've elected this setup over others because `mdadm` allows transparent support for booting (`grub` supports booting form it) and easy to manage setup.

For partitions, remember to allocate at least 500mb for `/boot` and as much as needed for your SO, for example, if only base OS is expected to have RAID protection, having a 20Gb partition will be enough, leaving the remaining disk to be used for a RAID0 device for allocating non-critical files.

For both partitions, set type with fdisk to `fd`: `Linux RAID autodetect`, and setup the two drives we'll use for initial setup using the same values, for example:

~~~bash
fdisk /dev/sda
n # for new partition
p # for primary
<ENTER> # for first sector
+500M # for size
t # for type
fd # for Linux RAID autodetect
n # new partition
p # primary
<ENTER>
+20G #for size
t #for type
2 # for select 2nd partition
fd # for Linux RAID autodetect
# n for new partition
p # for primary
<ENTER> # for first sector
<ENTER> # for remaining disk
t # for type
3 # for third partition
fd # for Linux RAID Autodetect
w # for Writing changes
~~~

And repeat that for `/dev/sdb`

At this point, we'll have both `sda` and `sdb` with the same partitions defined: `sd{a,b}1` with 500Mb for `/boot` and `sd{a,b}2` with 20Gb for `LVM` and the remaining disk for RAID0 LVM.

Now, it's time to create the raid device on top, for simplicity, I tend to use `md0` for /boot, so let's start with it.

## Creating the raid devices with Multiple Devices `mdadm`

Let's create the raid devices for each system, starting with `/boot`:

~~~bash
mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sda1 /dev/sdb1
mdadm --create /dev/md1 --level=1 --raid-devices=2 /dev/sda2 /dev/sdb2
mdadm --create /dev/md2 --level=0 --raid-devices=2 /dev/sda3 /dev/sdb3
~~~

Now, check the status of the raid device creation by issuing:

~~~bash
cat /proc/mdstat

Personalities : [raid1] [raid6] [raid5] [raid4]
md0 : active raid1 sda1[0] sdb1[1]
      534760 blocks level 1, 64k chunk, algorithm 2 [2/2] [UU]
            [==>..................]  recovery = 12.6% (37043392/292945152) finish=127.5min speed=33440K/sec
md1 : active raid1 sda2[0] sdb2[1]
      20534760 blocks level 1, 64k chunk, algorithm 2 [2/2] [UU]
            [=====>...............]  recovery = 25.9% (37043392/692945152) finish=627.5min speed=13440K/sec
...
~~~

When it finishes, all the devices will appear as synced, and we can start the installation of the operating system.

What I did, after this point, is to reboot the install media, so I could use `anaconda` installer to select manually the filesystems, creating `/boot` on `/dev/md0`, then the Physical Volume on `/dev/md1` for the operating system.

Select the `manual partitioning` during the installation to define above devices as their intended usage, and once it has been installed, create the additional Physical volume on `/dev/md2` and define the intended mountpoints, etc.

Enjoy!
