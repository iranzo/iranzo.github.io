---
author: Pablo Iranzo Gómez
title: Cloning Lego Dimensions tags
tags: lego, xbox, playstation, ps3, ps4, wii, dimensions, nfc, clone, ntag213
layout: post
date: 2019-09-29 16:24:36 +0200
comments: true
category: blog
description:
lang: en
slug: lego-dimensions-cloning
---
[TOC]

## Introduction

In the article [Lego Dimensions]({filename}2019-08-19-lego-dimensions.en.md), I covered all the available packs for playing with the console.

Unfortunately not all of them are available for purchase anymore except from collectionists, <brickset.com> or some resellers.

After some research, several pages provides instructions about the tags themselves and how to 'fix' or 'clone' them.

## Materials

Each base is a NFC tag `NTAG 213` which is either read only (characters) or rewritable (vehicles).

With an NFC writer/reader on your mobile phone, the tags can be cloned/copied so that you can 'repair' the broken ones, without buying again the pack (base can be opened with a precission screwdriver by pulling it out using the small marks (opposite in the base with `+` shape).

In order to 'create' your own, the following bill of materials is useful:

|    Item    |                 AliExpress                 |                       Amazon                        |
| :--------: | :----------------------------------------: | :-------------------------------------------------: |
|    Tags    | <http://s.click.aliexpress.com/e/dMeJ0gug> | <https://www.amazon.es/dp/B00NG4W3K2?tag=redken-21> |
| Hole Punch | <http://s.click.aliexpress.com/e/5U3WF4fq> | <https://www.amazon.es/dp/B007QJC8WG?tag=redken-21> |
|   Holder   | <http://s.click.aliexpress.com/e/oEAZCDnK> | <https://www.amazon.es/dp/B07CNTTVF9?tag=redken-21> |

## Insights

Each tag can be read/written with an app on your mobile (I've tested it with [Nexus 5](https://www.amazon.es/dp/B016B7INC2?tag=redken-21), [Sony Xperia Z5](https://www.amazon.es/dp/B013WSM36A?tag=redken-21), [Samsung Galaxy S8](https://www.amazon.es/dp/B06XXFHG6J?tag=redken-21) and [Samsung Galaxy Note 9](https://www.amazon.es/dp/B07FT169LZ?tag=redken-21)), and the 'trick' is to always 'read' first the tag and then write it with the modified parameters.

Each tag has in at the beginning the serial number, so that it can't be changed and then, there's a 'password' field used to validate.

This article [Manual para clonar figuras de Lego Dimensions](https://www.elotrolado.net/hilo_manual-para-clonar-figuras-de-lego-dimensions_2209995) includes two methods, one using an App that worked quite well called `ldtageditor`, which can be located at google via <https://www.google.com/search?client=firefox-b-d&q=ldtageditor+apk> and other using an app in the Android Play Store called [MIFARE++ Ultralight](https://play.google.com/store/apps/details?id=com.samsung.sprc.fileselector).

The 2nd App is 'harder' to use as it includes manually calculating ID's via a website or app (search for `ldcharcrpyto` or read this forum <http://www.proxmark.org/forum/viewtopic.php?id=2657&p=2>).

Trick here is:

- to use the tags and read before selecting char and writing it back
- Don't put characters that are not available in the tag, as those will not be recognized and tag will be unusable until you 'format' them (use NFC Tools app for that)

Doing this, you'll be able to clone or write the tags that were damaged and put new ones in their place to allow you continue playing as you did before!

There was also a 'ready-to-print' set of pics for the tags in one of the forum posts at <http://www.mediafire.com/file/b2d5a9dwj7ksry9/LD1inchimages.zip> which contains the images for each tag and possible vehicle.

Enjoy!