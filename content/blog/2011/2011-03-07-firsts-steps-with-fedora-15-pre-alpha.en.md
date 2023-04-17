---
layout: post
title: Firsts steps with Fedora 15 pre-alpha
date: 2011-03-07 17:26:00 +0100
author: Pablo Iranzo Gómez
tags:
  - fedora
  - foss
modified: 2023-04-17T21:48:16.162Z
categories:
  - FOSS
  - Fedora
---

Today I've decided to give it a try to F15-prealpha (expected to release tomorrow).

The upgrade performed in the unsupported way (getting and forcing install for newer fedora-release from a mirror then start issuing several yum upgrades) when reasonably good.

Only some minor dependency problems `et voilà`, system started fine.

Problems so far:

- Firefox 4 has a few approved extensions, I used the "nightly tester tools" to disable version check and enable most of the ones I had with 3.6.x without problems.
- Don't like gnome-shell at the moment
- Desktop icons disappeared...
- Menu bar is black and found no way to configure it yet
- Gnome-applets have some dependency problems and can't install or configure them, furthermore I lost my tray area on one of the computers but works fine on the other.

I hope that tomorrow's release of Alpha will fix some of them in order to warm-up for final launch (<http://fedoraproject.org/wiki/Releases/15/Schedule>)...

Update: wed 09/03/2011:

After 'Alpha' release:

- Like a bit more gnome-shell, but sometimes my desktop starts in compatibility (legacy) mode
- Active corners (upper left: show windows, favorites, search for apps, lower right: show tray)
- with empathy, notifications of new chats in bottom center of screen that let you answer in that area (but then if you open the window, it will 'random sort' the messages you wrote/received
- GDM will not allow you to login (there's an update on koji that updates `accountservice` that got positive karma today and will be pushed to updates repo)
- Under your user name in gnome-shell, there's no 'power off', just 'suspend' but that gets my desktop computer powered off in seconds, and the best of all, started again in seconds (and my computer is an Athlon 64 3Ghz with 2Gb ram from 2004) (<http://www.youtube.com/watch?v=xPRh1NvOhqI>)
- Still missing desktop icons
- Still missing gnome-applets :'(

Update Wed 16/Mar/2011

- Still missing desktop icons /gnome-applets
- Sometimes gdm doesn't show usernames, but you can enter username/password
- Evolution has a good integration with Google services (Contacts/Calendar/Gmail) so you can use it as an offline client
- Some bugs opened on bugzilla, but still more than 15 days for 'Beta', and a very good ratio of fixes :)

{{<enjoy>}}
