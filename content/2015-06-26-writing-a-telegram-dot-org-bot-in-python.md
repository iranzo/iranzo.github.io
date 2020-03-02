---
layout: post
title: Writing a Telegram.org bot in Python
date: 2015-06-26 17:12:30 +0200
comments: true
tags: Python, programming, telegram, foss, redken
description:
---

Hi,

[Telegram.org](http://telegram.org) recently announced the support for writing bots for their platform, by providing details at [https://core.telegram.org/bots](https://core.telegram.org/bots).

I was missing for a long time the ability to get a count on karma like we've on irc servers, so I started with it.

My first try is published at github repo in [https://github.com/iranzo/stampython](https://github.com/iranzo/stampython).

At the moment it just uses the polling inteface to check the new messages received on the channels the bot is in, and later processes them and send the relevant replies via messages.

Also, some other commands are missing like the ones on `redken` that we use on IRC, but at least, basic functionality is there and is usable.

Enjoy!

Pablo

BTW: the bot is not allowed to join channels (`@stampy_bot`) so it remains in a controlled environment until the code is made more robust, but I'm thinking about having a second `public` instance on `Openshift.redhat.com` for wider audience.
You can invite the `public` instance by inviting [@redken_bot](https://t.me/redken_bot)
