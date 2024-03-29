---
layout: post
title: OctoPress for Jekyll blogging
date: 2015-03-24 13:23:15 +0100
tags:
  - Jekyll
  - Markdown
  - OctoPress
  - FOSS
categories:
  - CMS
  - FOSS
lastmod: 2023-08-25T09:48:46.970Z
---

After testing for some days Jekyll and github.io for blog posting, I was missing some features of other CMS, so I started doing some search on how to automate many other topics while keeping simplicity on blog posting.

[OctoPress](http://octopress.org) Makes this extra step so you can still focus on your contents and of course have a nice template as starting point with integrations for some social plugins, etc.

Setup is well done if you follow the provided steps, without jumping anything, in my case, I moved my old pages (plain `jekyll + poole`) to OctoPress.

On Fedora and as my unprivileged user, I did:

- Install [`RVM`](http://octopress.org/docs/setup/rvm/)
  - Define in profile configuration to have `RVM` use 1.9.3 ruby as required by OctoPress
- Install other required libraries for [Setting up OctoPress](http://octopress.org/docs/setup/)
- [Configure OctoPress](http://octopress.org/docs/configuring/)
- [Set OctoPress for github](http://octopress.org/docs/deploying/github/)
- And from there, the `generate`, `preview` and `deploy` basics [for blogging](http://octopress.org/docs/blogging/)

One of the interesting things it that it uses two branches on git, `master` and `source`, where `master` is the one that github publishes (your live environment) and `source` is the actual code for your blog, templates, posts, etc that are later generated, previewed and deployed from above steps.

I'll be testing it for a while to see how it works, but so far, so good.
{{<enjoy>}}
