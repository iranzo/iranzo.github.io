---
layout: post
title: Migrate SPIP-RSS post feed to HTML
date: 2015-04-01 16:49:13 +0200
comments: true
tags: python, SPIP, markdown, html, foss
description:
---

I had my old blog based on [SPIP](http://www.spip.net), and I wanted to keep all the posts together, to make it easier to migrate in the future.

Initially, I migrated my posts from blogger, where there's an option to export the contents and some plugins to allow easier importing to markdown files (to be used by OctoPress), those were the recent posts, so part of the job was already done there.

Next step, was to migrate old posts on my SPIP site.

SPIP, being not as popular as other solutions, might lack plugins for importing the data, but has a nice feature: it allows to provide full article contents via RSS.

So:

- I entered into my site private area `/ecrire/`
- Entered to the administration section and under `Content`, I temporarily changed the syndication settings to provide full articles instead of just summary.
- Then, I visited the url for my user, but on the RSS generator template: `spip.php?page=backend&id_rubrique=6`, and saved it as file.xml

At this point I needed some software for automating the initial conversion, so I went to python's `feedparser` libraries to perform this with a bit of coding:

```python
url = "/path/to/your/xml/file.xml"

import codecs
import feedparser

feed = feedparser.parse(url)

for item in feed["items"]:
    filename = (
        item["date"][0:10] + "-" + item["link"][23:]
    )  # remove the first 23 chars from article url http+domain
    print filename
    with codecs.open(filename, "w", "utf-8") as f:
        f.write("---\n")
        f.write("layout: post\n")
        for elem in ["title", "date"]:
            f.write("%s: %s\n" % (elem, item[elem]))
        f.write("---\n")
        f.write(item["content"][0].value)
```

After each iteration, a new file was created using the old http link to the article (which already had stripped problematic characters).

Just moving those files to `source/_posts` allows me to re-publish them on a different site, and later work the conversion to markdown by using `pandoc` and some manual tuning.
