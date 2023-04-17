---
author: Pablo Iranzo Gómez
title: Galleria.io and PhotoSwipe
tags:
  - Pelican
  - pelican-elegant
  - photography
  - gallery
  - Instagram
  - OpenSource
  - open source
  - galleria.io
  - PhotoSwipe
  - FOSS
layout: post
date: 2020-02-12 07:30:24 +0100
categories:
  - tech
  - CMS
lang: en
modified: 2023-04-17T21:36:02.514Z
---

## Introduction

I was looking for an alternative for my (this) blog and hold pictures. I'm a lego fan so I wanted to get some pictures uploaded but without bloating the site.

In the article [Lego Mini Cooper MOC]({{<relref "2019-06-09-lego-mini-cooper-moc.en.md">}}) I did add lot of pictures, same for [Lego Chinese dinner]({{<relref "2019-06-28-chinese-dinner.en.md">}}) and [Lego Dragon Dance]({{<relref "2019-06-28-dragon-dance.en.md">}}).

I was checking and how telegram does handle some links and found that
Instagram 'links' get expanded to list the images inside directly to see if that could help in a task I was helping at [Pelican-Elegant theme](https://github.com/Pelican-Elegant/elegant) used at this site for creating a gallery.

## Instagram and multiple pictures

While doing some research, I found that apparently, to an Instagram URL you can append `?__a=1` and it will 'dump' a `xml' of the picture or gallery, like the following one for [this picture](https://www.instagram.com/p/B7yh4IdItNd/):

<div class="elegant-instagram" data-instagram-id="B7yh4IdItNd"></div>

In this case, the generated JSON, available at <https://www.instagram.com/p/B7yh4IdItNd/?__a=1> contains the information we required for getting image size, thumbnail, etc

The important there is that from a gallery ID, we can get a JSON without requiring any API key (which is required for Flickr for example).

I'm not an expert in JavaScript, but I did something which was useful enough to get the json, then process the internal code and separate in two cases, 'gallery ID' with one or multiple pictures. Using it, I was able to then consider using some Gallery Software to get them rendered.

## Galleria.io

<https://galleria.io> offers a nice gallery, which uses jQuery and also
accepts a `json` as input, so it was more or less straightforward to convert
from the json from Instagram to what Galleria.io required.

I used that to get an initial draft to be added to Pelican-Elegant, but as
the goal in the project is to remove dependency on jQuery it was discarded.

However, my personal research came part of another website that even not
directly from Instagram, takes a good advantage of defining a json of images
for showcasing pictures.

## PhotoSwipe

While discussing about Galleria, Talha from Pelican-Elegant found two other
projects and it was decided that [PhotoSwipe](https://photoswipe.com/) provided nice features, mobile
usage like pinch-in and pinch-out.

PhotoSwipe required extra steps like creating a `div` and using HTML tags for
putting pics (check the [official documentation for Pelican-Elegant
Galleries](https://next.elegant.oncrashreboot.com/photoswipe-gallery-using-raw-html))

One of the main problems was getting image size required (Galleria.io didn't
required it), but when using Instagram pictures we can grab the information
from the JSON.

Finally with the help from Talha, we got it also working with Instagram
[Gallery Embed Instagram Post](https://next.elegant.oncrashreboot.com/gallery-embed-instagram-post)

{{<enjoy>}}
