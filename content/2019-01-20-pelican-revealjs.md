---
author: Pablo Iranzo Gómez
title: Fixing pelican revealjs plugin
tags: pelican, foss, blog, python, github, blog-o-matic, linux, pandoc
layout: post
date: 2019-01-20 23:12:17 +0100
comments: true
category: tech
description:
---

[TOC]

## Introduction

After my recent talk about [blog-o-matic]({filename}2019-01-09-blog-o-matic.md), I was trying to upload somewhere the slides I used.

Since some time ago I started using Reveal-MD, so I could use MarkDown to create and show slides, but wanted also a way to upload them for consumption.

[Pelican-revealmd plugin](https://github.com/brookskindle/pelican-revealmd/) seemed to be the answer.

It does use pypandoc library and ['pandoc'](https://pandoc.org) for doing the conversion.

## The problems found

After some test, it had 3 issues:

- Images, specified with whatever _pelican_ formatting, where rendered not alongside the html
- Code blocks where not properly shown
- Title was shown as 'Untitled' in the generated html

For the 1st one, after reaching on #pelican on Freenode, it was clear that images should be placed alongside the html, and that required using '{static}', but pandoc was escaping it.

## The fixes

The first patch was to use a replace function on the text to move back `{` and `}` to the character that pelican will recognize and interpret.

Second patch was for the Title, initially, I did use python Beautiful Soup to replace the title tag on the HTML, it took a while, but it worked.

For 3rd one, there was no clear approach, as the html rendered was working, but not shown after using pelican. When also tried to use a newer pandoc version, the results were even worse.

Finally, I disected what I wanted from pypandoc module, and instead of using it, went to directly use the same shell command I was using.

As the templates for the rendered the pages should be similar, I moved to use the 'non-standalone' version of pandoc conversion, hence, instead of generating full html, I could reuse headers, css loading, etc and just put the content revelant for the slides, and at the same time, reuse article metadata like article.title, author, date to fill some values in the rendered html.

This also, rendered in two outcomes, 2nd patch was no longer needed in that form, and some other dependencies were removed (no more pypandoc, no more BeautifulSoup, etc)

The new version of the plugin has been contributed via PR, but while it is being accepted by original author, you can find the relevant version in the 'master' branch of <https://github.com/iranzo/pelican-revealmd>.

## Outcomes

This of course, has brought some outcomes:

- My blog can now render my `reveal-md` slides stored as `filename.revealjs`
- I've learned a bit on how Pelican plugins work
- Blog-o-Matic has been updated to include that support too, out of the box

Enjoy!
