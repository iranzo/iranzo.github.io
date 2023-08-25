---
author: Pablo Iranzo Gómez
title: AwesomeSlides for converting LibreOffice ODP into revealjs
tags:
  - Pelican
  - FOSS
  - blog
  - Linux
  - pandoc
  - LibreOffice
  - odp
  - ppt
  - presentations
layout: post
date: 2019-01-22 20:51:27 +0100
categories:
  - tech
  - CMS
lastmod: 2023-08-25T09:48:47.232Z
---

# Introduction

For some time now, I wanted to put the presentations I did in the past to be available, and since I've added support to [my blog to render revealjs slides]({{<relref "2019-01-20-pelican-revealjs.en.md">}}), I wanted to also put other presentations that I did in the past, probably (or for sure) outdated, but that were sitting in my computer drive.

The presentations already got several transformations, but in the actual status they are stored as LibreOffice ODP files, that made it a bit difficult.

Some software for the conversion, did generate them as 'screenshoots' for each slide, this however had some cons/pros:

- Pros:
  - Format was kept almost 100%
  - Easy to showcase with any 'gallery' plugin
- Cons:
  - Text was lost, so no links, no indexation, etc

Alternatively, I could add and attach via a link to the odp file for end users to download and reproduce, but that will increase blog size (no constrains, but sounded like nonsense to me), so I continued my research for a solution or workaround to use.

# The approach

Thanks to <https://github.com/cliffe/AwesomeSlides>, which uses perl and a set of common available libraries on any
distribution to do the job, I was able to convert my presentations from `odp` to `html` quite easily:

```sh
for file in *.odp; do
    perl convert-to-awesome.pl $file
done
```

This resulted in 'master' html files in the `slides_out` folder, plus a folder containing the images and other media used by the presentation.

AwesomeSlides does the conversion to 'revealjs' format, plus adds extra features, transitions, etc to make them fancier, but in my case I was interested in plain markdown, so the next one to the rescue has been `pandoc`

```sh
for file in *.html; do
    pandoc -t markdown $file -o $file.md
done
```

The end result of course is not clean at all and not directly usable by the [pelican plugin](http://github.com/iranzo/pelican-revealmd/) to render the images, etc.

# The post-processing

One of the things needed (and that I used for other slides) is to move the resulting
`md` file to the same folder as the images and move them into the `content/presentations` folder of my website source.

Once there, a set of find/replacements was required:

| find          | replacement  | description                                                                             |
| ------------- | ------------ | --------------------------------------------------------------------------------------- |
| \$folder      | ``           | Define images included as `` for pelican to pick them up                                |
| ---------     |              | Remove underlining after titles                                                         |
| `stangechars` | `normalchar` | Some characters were lost (accents, etc), replaced by another one, to later spell check |
| `\n\n\n`      | `\n\n`       | Remove extra new lines                                                                  |
| `-⠀⠀⠀⠀⠀`      | `-⠀`         | Remove extra spaces before paragraph                                                    |

Other manual steps involved

- Put ## in front of each title
- Adjust empty slides (--- followed by another ---)
- And a lot more :-)

The good thing, in the end, is that with some additional work, I was able to bring back 'online' my older presentations, now listed in the [presentations category]({category}presentations).
{{<enjoy>}}
