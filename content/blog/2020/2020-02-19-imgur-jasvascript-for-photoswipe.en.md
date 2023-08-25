---
author: Pablo Iranzo Gómez
title: JavaScript for imgur gallery generation for PhotoSwipe and Pelican-Elegant
tags:
  - pelican
  - pelican-elegant
  - photography
  - gallery
  - imgur
  - PhotoSwipe
layout: post
date: 2020-02-19 21:55:24 +0100
categories:
  - tech
  - CMS
lang: en
lastmod: 2023-08-25T09:46:05.138Z
---

Hi,

Using the following code from the Browser console:

```js
console.log("");
var images = $$("img");
for (each in images) {
  console.log(`
        <a href="${images[each].src}"  data-size="4032x3024">
            <img src="${images[each].src}" width="403" height="302"  alt="Image description" />
        </a>

    `);
}
console.log("</div>");
```

It will output a copy-paste ready code for integrating in your blog post and leverage the picture gallery.

{{<warning>}}
Review the `data-size` to make it match the image size as PhotoSwipe requires it to match image and adjust the `figcaption` entry.
{{</warning>}}
