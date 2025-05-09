---
title: Android TV and Netflix's tvq-pm-100 (5.2.5) error
tags:
  - Android
  - Netflix
  - tvq-pm-100
  - Kodi
author: Pablo Iranzo Gómez
layout: post
date: 2018-12-30 19:26:00 +0100
categories:
  - tech
lang: en
slug: AndroidTV-and-Netflix-tvq-pm-100
translationKey: AndroidTV-and-Netflix-tvq-pm-100
cover:
  relative: true
  image: netflix-tvq-pm-100.png
lastmod: 2025-02-12T09:33:58.997Z
---

# Android TV versus Android TV-Box

Android, being used in lot of mobile devices is also part of TVs and set-top boxes.

The main difference between both approaches is the user interface and applications.

Android TV-Box: it's like a tablet or mobile connected to a TV and usually requires external keyboard, often integrated in the remote.

Android TV: it's a version of Android that incorporates TV changes in the OS so that it can be controlled with an arrow cursor remote plus back, home and microphone key.

The range of apps also differs, TV-Boxes have the full range of apps at a cost: they are not optimized for screen usage and require to point and click on several places for operation, while on the other side Android TV does have a reduced set but those apps are prepared for being used with simpler controls that are more natural for a TV.

Android TV also has Chromecast support, so that you can not only replicate/mirror your mobile screen to the TV, but also `cast` content from apps supporting it, not only for playing, but also to play games between several users.

Among Android TV systems I've tested three:

- [NVIDIA Shield TV 🛒#ad](https://www.amazon.es/dp/B01NBJ6KZY?tag=redken-21) which acts both as Game Console and Android TV system
- [Xiaomi Mi Box 🛒#ad](https://www.amazon.es/dp/B07K3KC5CP?tag=redken-21) which contains the Android TV System as an addon for any TV with HDMI input
- [Sony Bravia Android TV 🛒#ad](https://www.amazon.es/dp/B01IW656UC?tag=redken-21) which directly integrates Android TV as the TV operating system

NVIDIA and Xiaomi both allow to 'convert' or 'upgrade' any TV to an Android TV box and additionally can be upgraded in the future for a cheaper price tag than upgrading a TV.

# Netflix

One of the features of an AndroidTV box is the ability to use it with [Amazon Prime Video](https://www.primevideo.com/?tag=iranzo-21) or with [Netflix](https://netflix.com).

Unfortunately, recently I started getting an error on the Xiaomi MiTV Box I bought for an older TV:

![Netflix tvq-pm-100 error](netflix-tvq-pm-100.png)

After searching for `tvq pm 5.2 5`, I got to this Netflix FAQ: <https://help.netflix.com/en/node/59709>

Which more or less solved nothing, even technical support said that their supported platforms are [Fire TV](https://www.amazon.es/dp/B01ETRGE7M?tag=redken-21), which was not the kind of answer I wanted to hear.

# Kodi to the rescue

After some more deep research, a post suggested to use:

- Kodi v18 ([nightly](https://mirrors.kodi.tv/nightlies/android/arm/master/) if not released when you're reading this)
- Enabling [Netflix Addon](https://forum.kodi.tv/showthread.php?tid=329767)

Once configured (email and password), I was able to use Kodi to access Netflix using Kodi as a workaround while the problem is solved.
{{<enjoy>}}
