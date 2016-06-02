---
layout: post
title: Podcasts with flexget and transmission
author: Pablo Iranzo Gómez
date: '2015-03-16T21:45:00.000+02:00'
tags: fedora
---

Some podcasts are available via rss feeds, so you can get notified of new episodes, so the best way I've found so far to automate this procedure is to use the utility 'flexget'.

Flexget can download an rss feed and get the `.torrent` files associated to them and store locally, which makes a perfect fit for later using Transmission's `watch` folder, to automatically add them to your download queue.

In order to do so, install `flexget` either via pip (`pip install flexget`) or using a package for your distribution a create a configuration file similar to this:



~~~
cat ~/.flexget/config.yml

tasks:
  download-rss:
    rss: http://URL/TO/YOUR/PODCAST/FEED
    all_series: yes
    only_new: yes
    download: /media/watch/

~~~

At each invokation of `flexget execute` it will access the rss feed, search
for new files and store the relevant `.torrent` files on the folder
`/media/watch` from where transmission will pick up the new files and add
them to your downloading queue for automatic download.
