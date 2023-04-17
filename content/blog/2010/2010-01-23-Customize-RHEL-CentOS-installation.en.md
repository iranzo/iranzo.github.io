---
layout: post
title: Customize RHEL/CentOS installation media (EL4/EL5+)
date: 2010-01-23T08:25:00.000Z
author: Pablo Iranzo Gómez
tags:
  - RHEL
  - CentOS
  - Linux
  - installation
  - FOSS
modified: 2023-04-17T21:48:28.302Z
categories:
  - FOSS
---

## Introduction

A standard install media, (let's talk about a DVD for easier start) has several files/folders at his root, but most important are:

- `isolinux` (where the loader lives)
- `images` (for extra files for installer to load)
- `Packages` for installation (`RedHat/` for EL4, `Server`/`Client` for EL5)

Usually, a distribution has, for its main binaries, more than 2 gigabytes of data, that enables one target to act as a multifunction server/workstation, but that you will not usually load on the same system. Furthermore, since the DVD creation, there have been so many updates/patches that make your installation a 'outdated' install that you'll need to upgrade to have recent patches.

Wouldn't it be better to have one install media suited for your target systems with all available updates applied?

## Preparing everything

First, we'll need to copy all of our DVD media to a folder in our hard drive, including those hidden files on DVD root (the ones telling installer which CD-sets are included and some other info).

Let's assume that we'll work on /home/user/DVD/

After we've copied everything from our install media, we'll start customizing :)

## DVD background image at boot prompt

We can customize DVD background image and even keyboard layout by tweaking `isolinux/isolinux.cfg` with all required fields (Check [`Syslinux`](http://syslinux.zytor.com/wiki/index.php/SYSLINUX) Documentation to check proper syntax)

On [`Kickstart: instalaciones automatizadas para anaconda`]({{<relref path="2008-05-11-Kickstart-instalaciones.es.md" lang="es">}}) (Spanish) you can also check how to create a kickstart, so you can embed it on this DVD and configure `isolinux.cfg` to automatic provision a system

## Including updates

The easiest way would be to install a system with all required package set from original DVD media, and then connect that system to an update server to fetch but not install them.

- EL4: `up2date -du # yum upgrade —downloadonly`
- EL5: `yum upgrade —downloadonly`

After you download every single update, you'll need to copy them to a folder like `/home/user/DVD/updates/`.

Well, now let's start the funny work:

For each package in updates/, you'll need to remove old version from original folder (remember: `Client/` `Server/` or `RedHat/RPMS` ), and place in that folder the updated one...

After some minutes, you'll have all updates in place... and you can remove the DVD/updates/ folder as it will be empty after placing each updated RPM in the folder where the previous versions was.

## Removing unused packages

Well, after having everything in place, we'll start removing unused files. Usually, we could check every package install status on 'test' system by checking rpm, but that's going to be a way lengthy task, so we can 'automate' it a bit by doing:

- If you have `ssh` password-less connection between your systems (BUILD and TARGET):

On BUILD system:

```bash
#!bash
for package in *.rpm
do
    NAME=`rpm -q —queryformat '%NAME' $package` ssh TARGET "rpm -q $NAME >/dev/null 2>&1 || echo rm $package" |tee things-to-do
done
```

- If you don't have `ssh` password-less setup (using private/public key authentication or Kerberos), you can do something similar this way:

On BUILD system:

```bash
#!bash
for package in *.rpm
do
    NAME=`rpm -q —queryformat '%NAME' $package` echo "$package:$NAME" > packages-on-DVD
done
```

Then copy that file on your TARGET system and running:

On TARGET system:

```bash
#!bash
for package in `cat packages-on-DVD`
do
    QUERY=`echo $package|cut -d ":" -f 2` FILE=`echo $package|cut -d ":" -f 1` rpm -q —queryformat '%NAME' $QUERY >/dev/null 2>&1 || echo rm $FILE|tee things-to-do
done
```

After you finish, you'll have a file named `things-to-do`, in which you'll see commands like `rm packagename-version.rpm`

If you're confident about it's contents, you can run `sh things-to-do` and have all 'not installed on TARGET' packages removed from your DVD folder.

## Adding extra software

In the same way we added updates, we can also add new software to be deployed along base system like monitoring utilities, custom software, hardware drivers, etc, just add packages to desired folders before going through next steps.

## Recreating metadata

After all our adds and removals, we need to tell installer that we changed packages, and update it's dependencies, install order, etc.

### EL4

This one is trickier, but it is still possible in a not so hard way, first of all, we need to update some metadata files (`hdlist`) and Package order for installation, it can be difficult if we add extra packages, as we'll have special care:

Generate first version of `hdlists`:

```bash
#!bash
export PYTHONPATH=/usr/lib/anaconda-runtime:/usr/lib/anaconda
/usr/lib/anaconda-runtime/genhdlist —withnumbers /home/user/DVD/
/usr/lib/anaconda-runtime/pkgorder /home/user/DVD/ i386 |tee /home/user/order.txt
```

Review order.txt to check all packages added by hand to check correct or include missing packages and then continue with next commands:

```bash
#!bash
export PYTHONPATH=/usr/lib/anaconda-runtime:/usr/lib/anaconda
/usr/lib/anaconda-runtime/genhdlist —withnumbers /home/user/DVD/ —fileorder /home/user/order.txt
```

### EL5

Using `createrepo` we'll recreate metadata, but we've to keep care and use comps.xml to provide 'group' information to installer, so we'll need to run:

```bash
#!bash
createrepo -g /home/DVD/Server/repodata/groupsfile.xml /home/DVD/Server/
```

## Finishing

At this step you'll have a DVD structure on your hard drive, and just need to get an ISO to burn and test:

```bash
#!bash
mkisofs -v -r -N -L -d -D -J -V NAME -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -x lost+found -m .svn -o MyCustomISO.iso /home/user/DVD/
```

Now, it's time to burn MyCustomISO.iso and give it a try ;-)

Post Datum: While testing is just better to keep using rewritable media until you want to get a 'release'

{{<enjoy>}}
