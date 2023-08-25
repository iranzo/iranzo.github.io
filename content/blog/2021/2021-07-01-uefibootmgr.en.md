---
author: Pablo Iranzo Gómez
title: UEFI boot order change
tags:
  - FOSS
  - UEFI
  - efibootmgr
layout: post
date: 2021-07-01 22:00:00 +0200
categories:
  - tech
lastmod: 2023-08-25T09:46:05.194Z
---

Hi,

In case you've a dual boot machine, sometimes it might happen that `grub` menu is no longer appearing.

For systems using regular BIOS, a `grub-install` against the device it was installed might be required, but when using UEFI, it's really easy to use a rescue media and execute `efibootmgr` to alter the boot order.

When executing `efibootmgr`, it might output some information like this:

```sh
BootCurrent: 0001
Timeout: 0 seconds
BootOrder: 0001,0019,001D,001C,0017,0018,001A,001B,001E,001F,0020,0000
Boot0000* Windows Boot Manager
Boot0001* Fedora
Boot0010  Setup
Boot0011  Boot Menu
Boot0012  Diagnostic Splash Screen
Boot0013  Lenovo Diagnostics
Boot0014  Startup Interrupt Menu
Boot0015  Rescue and Recovery
Boot0016  MEBx Hot Key
Boot0017* USB CD
Boot0018* USB FDD
Boot0019* NVMe0
Boot001A* NVMe1
Boot001B* ATA HDD2
Boot001C* ATA HDD3
Boot001D* ATA HDD0
Boot001E* ATA HDD1
Boot001F* USB HDD
Boot0020* PCI LAN
Boot0021* IDER BOOT CDROM
Boot0022* IDER BOOT Floppy
Boot0023* ATA HDD
Boot0024* ATAPI CD
```

Note there, the `BootCurrent` and the `BootOrder`, the numbers in the `BootOrder` correspond to the `Boot####` that are listed below it.

Once we're sure about the boot order we want (for example, to restore booting into grub), execute:

```sh
efibootmgr -o 0001,0000,0010,0011
```

But, choosing the right order you want for your system.

{{<enjoy>}}
