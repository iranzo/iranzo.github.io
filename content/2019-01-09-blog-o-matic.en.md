---
author: Pablo Iranzo Gómez
title: Blog-o-Matic - quickly get a GitHub hosted blog with Pelican, Elegant with little setup steps.
tags: Pelican, FOSS, Travis, CI/CD, Elegant, blog, Python, Github, blog-o-matic, Linux, continuous integration, continuous delivery
layout: post
date: 2019-01-09 22:00:47 +0100
comments: true
category: tech
description:
---

[TOC]

# Introduction

I've already covered some articles about automation with Travis-CI, GitHub,
and one step that seems a show-stopper for many users when trying to build a
website is on one side, the investment (domain, hosting, etc), the backend
being used (WordPress, static generators, etc)...

While preparing a talk for a group of co-workers covering several of those aspects, I came with the idea to create Blog-o-Matic, implementing many of those 'learnings' in a 'canned' way that can be easy to consume by users.

# The approach

Blog-o-Matic, uses several discussed topics so far:

- [Github](https://github.com) and GitHub Pages for hosting the source and the website
- [Travis-CI.org](https://travis-ci.org) for automating the update and generation process
- ['Pelican'](https://blog.getpelican.com/) for static rendering of your blog from the markdown or `asciidoc` articles
- ['Elegant'](https://github.com/Pelican-Elegant/elegant) for the 'Theme'
- [peru](https://github.com/buildinspace/peru) for automating repository upgrades for plugins, etc

The setup process is outlined at its [`README.md`](https://github.com/iranzo/blog-o-matic/) and just requires a few steps to setup that, from that point, will allow you to get your website published each time you commit a new document to the content folder.

You can also check the 'generated' website after installation via <https://iranzo.github.io/blog-o-matic>

Do not forget to update your `pelican.conf` file for fine-tuning and customization.
