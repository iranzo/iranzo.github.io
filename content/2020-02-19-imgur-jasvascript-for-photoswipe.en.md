---
author: Pablo Iranzo Gómez
title: JavaScript for imgur gallery generation for PhotoSwipe and Pelican-Elegant
tags: pelican, pelican-elegant, photography, gallery, imgur, PhotoSwipe
layout: post
date: 2020-02-19 21:55:24 +0100
comments: true
category: tech
description:
lang: en
---

Hi,

Using the following code from the Browser console:

```js
console.log(
  '<div class="elegant-gallery" itemscope itemtype="http://schema.org/ImageGallery">'
);
var images = $$("img");
for (each in images) {
  console.log(`<figure itemprop="associatedMedia" itemscope itemtype="http://schema.org/ImageObject">
        <a href="${images[each].src}" itemprop="contentUrl" data-size="4032x3024">
            <img src="${images[each].src}" width="403" height="302" itemprop="thumbnail" alt="Image description" />
        </a>
        <figcaption itemprop="caption description">Image description</figcaption>
    </figure>`);
}
console.log("</div>");
```

It will output a copy-paste ready code for integrating in your blog post and leverage the picture gallery.

!!! warning

    Review the `data-size` to make it match the image size as PhotoSwipe requires it to match image and adjust the `figcaption` entry.
