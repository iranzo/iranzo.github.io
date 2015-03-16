---
layout: post
title: Podscasts with flexget and transmission
author: Pablo Iranzo Gómez
date: '2015-03-16T21:45:00.000+02:00'
tags: 
---

Some podcasts are available via rss feeds, so you can get notified of new episodes, so the best way I've found so far to automate this procedure is to use the utility 'flexget'.

Flexget can download an rss feed and get the `.torrent` files associated to them and store locally, which makes a perfect fit for later using Transmission's `watch` folder, to automatically add them to your download queue.