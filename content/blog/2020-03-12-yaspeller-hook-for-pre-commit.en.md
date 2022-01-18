---
author: Pablo Iranzo Gómez
title: Yaspeller hook for pre-commit
tags:
  - node
  - pre-commit
  - git
  - foss
  - yaspeller
  - tips
layout: post
date: "2020-03-12 14:38:00 +0100"
category: tech
lang: en
slug: yaspeller-hook-for-pre-commit
modified: "2022-01-17T12:19:31.624Z"
---

I've made a PR that got merged into Yaspeller repository which adds support for `pre-commit` to spell check your files.

It requires simple configuration, just add this snippet to your `.pre-commit-config.yaml`:

```yaml
- repo: https://github.com/hcodes/yaspeller.git
  rev: master
  hooks:
    - id: yaspeller
      files: "\\.en\\.md"
```

The plugin will then initialize and spell check your files via `yaspeller`. It will use the standard `.yaspeller.json` file for dictionary and settings and automate it for each new commit you work on.

{{<important >}}

If you were checking this information, note that I've made and get merged a PR to yaspeller so that we now use directly their repository. The snippet above was updated to reflect my current settings on this site (and only check articles in English).

{{</important>}}

Hope you like it!
