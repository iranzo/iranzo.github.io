---
author: Pablo Iranzo Gómez
title: Logitech R400 remote presentation controller on Linux
tags:
  - Fedora
  - Logitech
  - R400
  - Linux
  - Custom keyboard mapping
layout: post
date: 2022-04-01T07:31:42.603Z
categories:
  - tech
  - FOSS
modified: 2022-05-04T13:32:56.654Z
cover:
  image: https://m.media-amazon.com/images/I/51-7XfmB4ZL.jpg
---

Since long ago I had it in my mind getting one remote presenter, but most presenters just had two buttons, and the ones that looked to be valid for my use case, required four and seems that only `Rii` had similar devices, but I din't went for it as it was not a huge need, so I ended up with a mini keyboard I had for Rasbperry Pi and some debugging in case I had that need.

But yesterday I found in the recycling IT area, together with several really old computers, a [Logitech R400 presentation remote](https://www.amazon.com/dp/B002GHBUTK?tag=redken08-20). It has one of those rubber coatings that make it comfortable at hand when it's new, but it's sticky once it gets older (had similar experience with other stuff, even umbrellas...)

Some alcohol and a soft cloth helped removing that stickyness, so next step was to test it... plugged the receiver in the usb port, and put two batteries in... and it powered up, bot left and right buttons were working, and the laser pointer. Thing is that the remote has two additional buttons for starting presentation and going to blank screen that didn't worked.

In a rush, I tought about opening it, thinking that the reason of having it discarded was that one, but nothing strange in the inside, everything was clean, no battery spill, etc, so I reassembed and started looking for information about it.

Using `xev` I was able to see that the key buttons were received on the computer, the one on the left, provided two different key codes and the one on the right just one, but was not mapped to anything.

After some search, I found this [blogpost](https://derickrethans.nl/logitech-r400.html), but a copy-paste didn't worked... seems that the USB receiver had changed the identifier in the meantime so I had to update to match mines.

First of all, I did checked with `lsusb` the device ID and Vendor ID, which was `046D` and `C52D`, so I used those values when filling the next two files.

First, I created `/etc/udev/hwdb.d/99-logitech-r400.hwdb`:

```console
# The lower left button actually emits two
# different scancodes depending on the state of
# the "presentation".
# E.g. one code to start and one to stop.
keyboard:usb:v046DpC52D
  KEYBOARD_KEY_70029=up
  KEYBOARD_KEY_7003E=up
  KEYBOARD_KEY_70037=down
  KEYBOARD_KEY_7004B=left
  KEYBOARD_KEY_7004E=right
```

This file is mapping the two events in the left button to be 'up' and the one on the right to be 'down'... I did this because in the past I used to do [some presentations]({{< ref "/tags/reveal" >}}) using reveal.js and it was interesting to have those kind of several-level presentations, so that you could go in deep on a topic or move to next one depending on the time available

and `/etc/udev/rules.d/99-logitech-r400.rules`:

```
SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c52d", IMPORT{builtin}="hwdb 'keyboard:usb:v046DpC52D'", RUN{builtin}+="keyboard"
```

The first file, defines the key mappings, so that the actual 4 buttons, work as I wanted, and the second one, ensures that when the device is plugged, the mappings will be loaded... after this, just unplug and replug, and voilà, the presenter was working perfectly... so nice finding, nice recycling via 'reuse' and new toy!.

Enjoy!
