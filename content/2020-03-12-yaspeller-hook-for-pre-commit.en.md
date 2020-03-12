---
author: Pablo Iranzo Gómez
title: Yaspeller hook for pre-commit
tags: node, pre-commit, git, foss, yaspeller
layout: post
date: 2020-03-12 14:38:00 +0100
comments: true
category: tech
description:
lang: en
slug: yaspeller-hook-for-pre-commit
---

I've created a repository at <https://github.com/iranzo/precommit-hooks> which adds support for `pre-commit` to spell check your files.

It requires simple configuration, just add this snippet to your `.pre-commit-config.yaml`:

```yaml
- repo: https://github.com/iranzo/precommit-hooks.git
  rev: master # Use the sha / tag you want to point at or master
  hooks:
    - id: yaspeller
      args: ["--find-repeat-words", "--ignore-digits", "--ignore-urls"]
```

The plugin will then initialize and spell check your files via `yaspeller`. It will use the standard `.yaspeller.json` file for dictionary and settings and automate it for each new commit you work on.

Hope you like it!
