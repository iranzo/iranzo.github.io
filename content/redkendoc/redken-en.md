---
author: Pablo Iranzo Gómez (pablo.iranzo@gmail.com)
title: Telegram Redken bot documentation
tags: foss, telegram, python, redken
layout: post
date: 2019-03-04 18:34:14 +0100
comments: true
category: tech
description:
lang: en
slug: telegram-redken_bot-documentation
draft: true
---

[TOC]

# Redken Manual

This document contains some information about regular Redken <https://t.me/redken_bot> usage and some advanced settings.

## Introduction

By default, new groups where the bot is added are just ready to start being used.

Also, while nothing is set against, you could use `/gconfig` to configure several aspects of it like:

- `modulo` (to just report karma every `modulo` points)
- `stock` (to define the stock tickers to query when invoking `stock`)

Once you started chatting with the bot, you can also use /hilight `word` so messages containing that word will be forwarded to you as a private message.

By default karma in channels is private to that group, but also, groups can be linked.

On the channel to become `master` execute: `/admin link master` and it will generate a code (token) to link against just once.

On the channel to be linked against `master`, a.k.a. `slave`, execute: `/admin link slave <token>` where `token` is the code received as reply to the command in master channel.

Also, as per general usage:

- `word++` to add karma
- `word--` to remove karma
- reply to message with '++', '--' or '==' to add or remove karma to user of prior message or to the same words that were used
- `/quote add username text` to add a quote for given username with the following text as message
- `/quote username` to retrieve a random quote for that username.
- `@all` to ping all usernames for users in a channel
- `@all++` to give karma to all usernames in a channel
- `stock <ticker>` to get trading quote for ticker in stock market
- `/hilight <add|delete|list> <word>` Adds/deletes word or lists words that will cause a forward to notify you
- `/feed <add|delete|list> name url` Adds/deletes/lists a new feed form URL on channel
- `/cn <word>` To get a random Chuck Norris fact related with provided word (or random)

### Bargains/Deals

Lists amazon bargains/deals published without duplicated during 24 hours, matching ones will be sent privately by <https://t.me/redken_bot>

- `/ofertas add <words>` to add a new word to the ofertas watch
- `/ofertas remove <words>` to remove a new word to the ofertas watch
- `/ofertas show` to show the words being watched

Lists amazon bargains/deal published without duplicated during 24 hours, matching ones will be sent to GROUP by <https://t.me/redken_bot>

- `/gofertas add <words>` to add a new word to the ofertas watch
- `/gofertas remove <words>` to remove a new word to the ofertas watch
- `/gofertas show` to show the words being watched

## User/chat configuration

- common
    - currency: EUR
    - modulo: 1 (to just show karma every X/modulo points, 0 to disable)
    - stock: stock tickers to check
    - cleanlink: True if we want links to be expanded and removed
    - cleankey: Regexp to replace, for example tag=
- chat
    - isolated: False, if true, allow link, all karma, etc is tied to GID
    - link: empty, if defined, channel is slave to a mater
    - admin: List of admins of channels, default empty: everyone
    - maxage: chats older than this will be removed
    - silent: makes stampy not to output messages to that chat
    - welcome: outputs the text when a new user joins the chat, replacing "$username" by user name

## Extra commands

Only for admin user in groups or for individuals against the bot

### Configuration

The bot, once token has been used and admin has been set, will store that information in the database, so you can control it from a chat window

- `/[g|l]config show` will list actual defined settings
- `/[g|l]config set var=value` will set one of those settings with a new value
    - As of this writing (verbosity, url for api, token, sleep timeout, owner, database, run in daemon mode)
- `/[g|l]config delete var` will delete that variable from configuration.

### Karma

- `/skarma word=value` will set specified word to the karma value provided.

### Auto-karma triggers

Bot allows to trigger auto-karma events, so when keyword is given, it will trigger an event to increase karma value for other words

- `/autok key=value` Will create a new auto-karma trigger, so each time `key` is used, it will trigger value++ event
- `/autok list [word]` Will show current defined autokarma triggers and in case a word is provided will search based on that word
- `/autok delete key=value` will delete a previously defined auto-karma so no more auto-karma events will be triggered for that pair

### Alias

Bot allows to setup aliases, so when karma is given to a word, it will instead add it to a different one (and report that one)

- `/alias key=value` Will create a new alias, so each time `key++` is used, it will instead do value++
    - This operation, sums the previous karma of `key` and `value` and stores it in value so no karma is lost
    - Recursive aliases can be defined, so doing:
        - `/alias lettuce=vegetable`
        - `/alias vegetable=food`
        - `lettuce++` will give karma to `food`.
    - Alias can be defined to groups of words so, it can be defined to have:
        - `/alias friday=tgif tfsmif`
        - `friday++` will increase karma on `tgif` and `tfsmif`.
- `/alias list` Will show current defined aliases
- `/alias delete key` will delete a previously defined alias so each word gets karma on its own

### quote

- `/quote del id` to remove a specific quote id from database
