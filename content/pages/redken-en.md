---
author: Pablo Iranzo Gómez
title: @redken_bot
tags: foss, telegram, python, redken
layout: post
date: 2019-03-04 18:34:14 +0100
modified: 2021-03-09 10:07:00 +02:00
comments: true
category: tech
description:
lang: en
slug: redken_bot
draft: true
---

[TOC]

# Redken Manual

This document contains some information about regular Redken <https://t.me/redken_bot> usage and some advanced settings.

## Introduction

By default, new groups where the bot is added are just ready to start being used.

General usage:

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
- `/remind <add|delete|list> name interval text` Adds/deletes/lists a new reminder for interval in channel, interval can be specified as '1y2m3w5d'
- `/ical <add|delete|list> name url` Adds/deletes/lists a new ical url to print events happening during the day
- `/cn <word>` To get a random Chuck Norris fact related with provided word (or random)
- `/excuse` To get a random excuse

Also, while nothing is set against, you could use `/gconfig` to configure several aspects of it like:

- `modulo` (to just report karma every `modulo` points)
- `stock` (to define the stock tickers to query when invoking `stock`)

Once you started chatting with the bot, you can also use /hilight `word` so messages containing that word will be forwarded to you as a private message.

By default karma in channels is private to that group, but also, groups can be linked.

On the channel to become `master` execute: `/admin link master` and it will generate a code (token) to link against just once.

On the channel to be linked against `master`, a.k.a. `slave`, execute: `/admin link slave <token>` where `token` is the code received as reply to the command in master channel.

#### Special notes

- Use `word` for regular substring match in include
- Use `!word` for regular substring exclude
- Use `$word` for whole word matching in include

### UIDEnforcer

Adds UID (as reported via /info) to the list of safe members of a chat, anyone else, will be Kicked

- `/uidenforcer add <UID>` to add a new UID to safe list
- `/uidenforcer remove <UID>` to remove a UID from safe list
- `/uidenforcer list` to show the UIDs in safe list

Once the list of UID's is ready, and the bot is set as Group Administrator, enable the check (every hour) by running `/gconfig set safelist=True` on your group to have the bot start checking on next scheduled execution.

BEWARE: If the list is created and setting enabled, bot will start kicking all other users in the chat, ensure that you're the creator or your user has been whitelisted or you might be kicked out too.

### Red Hat Jobs

Lists Red Hat Jobs published at <https://t.me/rhjobs> that have `word` in it:

- `/rhjobs add <words>` to add a new word to the rhjobs watch
- `/rhjobs remove <words>` to remove a new word to the rhjobs watch
- `/rhjobs list` to show the words being watched

## User/chat configuration

- common
  - `currency`: EUR
  - `modulo`: 1 (to just show karma every X/modulo points, 0 to disable)
  - `stock`: stock tickers to check
  - `cleanlink`: True if we want links to be expanded and removed
  - `cleankey`: Regexp to replace, for example tag=
  - `splitkarmaword`: Set to 'False' to make that `johndoe.linux.expert++` stops reporting karma to the word and to `johndoe`
  - `lang`: set to language of choice to get some strings translated into supported languages <https://poeditor.com/join/project/ubTVkikm1R> and override autodetected language.
  - `privacy`: Enables privacy for forwarded messages, if a message is
    forwarded and the config is set, redken will remove original message and
    resend text to the chat so that the original sender is removed but
    forwarder is credited. If value is set to `silent` it will just clean the message forwarder.
- chat
  - `isolated`: False, if true, allow link, all karma, etc is tied to GID
  - `link`: empty, if defined, channel is slave to a mater
  - `admin`: List of admins of channels, default empty: everyone
  - `maxage`: chats older than this will be removed
  - `silent`: makes stampy not to output messages to that chat
  - `welcome`: outputs the text when a new user joins the chat, replacing "\$username" by user name
  - `usernamereminder`: Set this `False` to stop reminding new users to get a username to get the most out of karma commands.
  - `inactivity`: Set this to the number of days without user activity before kicking it out.
  - `removejoinparts`: Set this to automatically remove 'User XXX has joined' or 'User XXX has left' messages from the groups.

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

### Auto-gif triggers

Bot allows to trigger gif sending when a keyword is given.

- `/autog key=value` Will create a new auto-gif trigger, so each time `key` is used, it will trigger gif send event
- `/autog list [word]` Will show current defined autogif triggers and in case a word is provided will search based on that word
- `/autog delete key=value` will delete a previously defined auto-gif so no more gifs will be sent for that keyword

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
