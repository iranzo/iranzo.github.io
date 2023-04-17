---
layout: post
title: Mount disk images
date: 2008-07-18T06:17:02.000Z
author: Pablo Iranzo Gómez
tags:
  - Linux
  - Xen
  - foss
modified: 2023-04-17T21:50:19.409Z
categories:
  - FOSS
---

I've been using a Xen guest under RHEL 5.2 to hold this Webserver, and because of failures, I choose to keep a copy of the full disk image on another machine.

Having to transfer the full disk in the network means stop the server (Xen guest),
`rsync` the image on disk (wait 40 minutes), then start guest again.

After doing the initial image transfer, it would be easier to just sync updated files, but... how to loop mount a full disk?

In my case, the HDD image contained a partition for `/boot` and a partition for a LVM pv.

First, I needed to check Number of cylinders in virtual disk inside Xen Guest. Using `fdisk` I could check that number, for example, 777.

On the remote system, the one with the full image transferred previously I could then do:

```bash
#!bash
fdisk /var/lib/xen/images/GUEST.img -C 777 -l -u #  and will yield something like:

255 heads, 63 sectors/track, 777 cylinders, 0 sectores en total
Unidades = sectores de 1 * 512 = 512 bytes
Disposit. Inicio Comienzo Fin Bloques Id Sistema
/var/lib/xen/images/GUEST.img1 * 63 208844 104391 83 Linux
/var/lib/xen/images/GUEST.img2 208845 12482504 6136830 8e Linux LVM
```

In this case, as I want to access my LVM volume, so I need to convert the partition start to a size, so:

```bash
#!bash
START=512*208845 = 106928640
```

and then thanks to `losetup`:

```bash
#!bash
libre=`losetup -f` #Get a free loop device
losetup -o 106928640 $libre /var/lib/xen/images/GUEST.img #setup the device for the 2nd partition
pvscan #scan for LVM's pv
vgscan # same for VG
lvscan # same for LV's
lvchange -a y /dev/GUESTvg #activate LV's on 'GUESTvg' VG
```

and mount our drives doing `mount /dev/GUESTvg/LVMunit` where desired ;)

At this point I can just run:

```bash
#!bash
rsync -avur —perms —progress —delete remoteserver:/ /mnt/DISKIMAGE
```

And get a 'working' copy of the remote machine but just copying changed elements.
{{<enjoy>}}
