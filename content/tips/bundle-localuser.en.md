---
author: Pablo Iranzo Gómez
categories:
  - tech
  - ruby
  - bundle
  - gems
title: Install gems on local user folder instead of system wide
tags:
  - ruby
  - FOSS
date: 2024-01-16T16:27:50.658Z
lastmod: 2024-01-16T16:32:56.277Z
---

In order to test locally a Gemfile, define local path for the gems to avoid attempting to write to system-wide folders:

```sh
bundle config set --local path '/home/username/.gem'
bundle install
```
