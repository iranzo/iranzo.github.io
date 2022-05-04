---
author: Pablo Iranzo Gómez
title: "@redken_bot"
tags:
  - foss
  - telegram
  - python
  - redken
layout: post
date: 2019-03-04 18:34:14 +0100
modified: 2022-05-04T13:45:08.764Z
categories:
  - tech
  - redken_bot
description: Learn about Redken Telegram Bot usage and configuration settings.
lang: en
slug: redken_bot
translationKey: redken_bot
draft: false
url: /redken_bot
---

# Redken Manual

This document contains some information about regular Redken <https://t.me/redken_bot> usage and some advanced settings.

## Introduction

By default, new groups where the bot is added are just ready to start being used.

General usage and features:

- `word++` to add karma
- `word--` to remove karma
- reply to message with '++', '--' or '==' to add or remove karma to the user of the replied message or to the same words that were used
- `/quote add username text` to add a quote for a given username with the following text as the message
- `/quote username` to retrieve a random quote for that username.
- `@all` to ping all usernames for users in a channel
- `@all++` to give karma to all usernames in a channel
- `stock <ticker>` to get the trading quote for ticker in stock market
- `/hilight <add|delete|list> <word>` Adds/deletes word or lists words that will cause a forward to notify you
- `/feed <add|delete|list> name url` Adds/deletes/lists a new feed form URL on channel
- `/remind <add|delete|list> name interval text` Adds/deletes/lists a new reminder for interval in channel, interval can be specified as '1y2m3w5d'
- `/ical <add|delete|list> name url` Adds/deletes/lists a new ical url to print events happening during the day
- `/cn <word>` To get a random Chuck Norris fact related with the provided word (or random)
- `/excuse` To get a random excuse
- Spam check for the messages based on the availability of database to train the bot, and only if certainty level is over or equal to `85%`.

Also, while nothing is set against, you could use `/gconfig` to configure several aspects of it like:

- `modulo` (to just report karma every `modulo` points)
- `stock` (to define the stock tickers to query when invoking `stock`)

Once you started chatting with the bot, you can also use /hilight `word` so messages containing that word will be forwarded to you as a private message.

By default karma in channels is private to that group, but also, groups can be linked.

On the channel to become `master` execute: `/admin link master` and it will generate a code (token) to link against just once.

On the channel to be linked against `master`, a.k.a. `slave`, execute: `/admin link slave <token>` where `token` is the code received as reply to the command in master channel.

### UIDEnforcer

Adds UID (as reported via /info) to the list of safe members of a chat, anyone else, will be kicked

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

The bot, once token has been used and admin has been set, will store that information in the database, so you can control it from a chat window

- `/[g|l]config show` will list actual defined settings (`/gconfig`, `/lconfig` or `/config`)
- `/[g|l]config set var=value` will set one of those settings with a new value
  - As of this writing (verbosity, url for api, token, sleep timeout, owner, database, run in daemon mode)
- `/[g|l]config delete var` will delete that variable from configuration.

The available list of configuration options that can be used depending on private or chats is listed below:

### common

- `currency`: EUR
- `modulo`: 1 (to just show karma every X/modulo points, 0 to disable)
- `stock`: stock tickers to check
- `cleanlink`: True if we want links to be expanded and removed
- `cleankey`: Regexp to replace, for example tag=
- `splitkarmaword`: Set to 'False' to make that `johndoe.linux.expert++` stops reporting karma to the word and to `johndoe`
- `lang`: set to language of choice to get some strings translated into supported languages <https://crowdin.com/project/stampython> and override autodetected language.
- `privacy`: Enables privacy for forwarded messages, if a message is
  forwarded and the config is set, redken will remove original message and
  resend text to the chat so that the original sender is removed but
  forwarder is credited. If value is set to `silent` it will just clean the message forwarder.

### chat

- `isolated`: False, if true, allow link, all karma, etc is tied to GID
- `link`: empty, if defined, channel is slave to a mater
- `admin`: List of admins of channels, default empty: everyone
- `maxage`: chats older than this will be removed
- `silent`: makes stampy not to output messages to that chat
- `welcome`: outputs the text when a new user joins the chat, replacing "\$username" by user name
- `usernamereminder`: Set this `False` to stop reminding new users to get a username to get the most out of karma commands.
- `inactivity`: Set this to the number of days without user activity before kicking it out.
- `hiordie`: Set this to the initial number of minutes that a user has to say something on the chat, similar to grace but for shorter periods
- `grace`: Set this to the initial grace period in days for user to say something when added to a channel before being kicked out of `inactivity` (fakes the join date as `grace` days before being kicked out of max `inactivity`)
- `removejoinparts`: Set this to automatically remove 'User XXX has joined' or 'User XXX has left' messages from the groups.
- `enableall`: Set this to `admin` or `karma` or `false` to allow being used only by admins, allow regular users to just give karma but no pinging or to disable it in your chat.
- `spamcheck`: Set this to `false`, `True` or `auto` to process the text messages with Machine Learning predictions about spam. This only works in English right now and only while the model is `85%` accurate or more. Leaving the default (`True`), will show two buttons for the messages when it is considered SPAM, if confirmed, spam actions will happen. In `auto` mode, spam actions will trigger automatically if the message is considered spam.
- `alladmins`: Set this to True to make all users in chat being able to use administrative commands, by default (`False`) means that only chat admins can run the commands.

{{<important title="SPAM actions means">}}

- Delete spam message
- Submit spam message to database of spam
- Add spammer userid to database
- Kick user from the group

{{</important>}}

## Extra commands

Only for admin user in groups or for individuals against the bot

- `/reload_admins`: Uses telegram API to find admins and populate the `admin` variable for commands that require admin access.
- `/spam`: reports a message as SPAM to redken
- `/thanks [add|list|delete]`: Manage the list of words that, when replied, give karma to original sender
- `/spoiler`: Reploy to a message with this to delete it and send it back with hidden text

### Karma

- `skarma word=value` will set specified word to the karma value provided.

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

### Alias team

Bot allows to setup team aliases, so it can ping several users in a chat

- `/ateam team=members` Will create a new team, so when `@team` is used, it will ping each member's username (prepending @ to each word defined as members)
  - Teams can be defined to groups of words so, it can be defined to have:
    - `/ateam ateam=face murdock hannibal mr-t`
- `/ateam list` Will show current defined teams
- `/ateam delete team` will delete a previously defined team

### quote

- `/quote del id` to remove a specific quote id from database
