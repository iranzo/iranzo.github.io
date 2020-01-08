---
author: Pablo Iranzo Gómez
title: New features in descuenbot: Hide items with current price lower than average
tags: python, redken, descuenbot, deal, chollo, bargain, rabbate, soldes
layout: post
date: 2020-01-07 14:35:00 +0100
comments: true
category: blog
description:
lang: en
---
[TOC]

## Introduction

Usually when one expects to see more 'deals', the goal is to see actually 'more information', but one of the goals when the bot was updated to check for *actual* deals the goal was to in fact, reduce them.

In post about [the bot]({filename 2019-02-07-redken_bot-amazon-discount.md}) (now available on Telegram at [@descuenbot](https://t.me/descuenbot)), the internals of how it worked where shared, and in brief, the main advantage was to `avoid duplicates for the same deal in a 24 hour window`, this allows already to reduce 'a lot' the amount of deals that were received if you were following lot of channels and instead started following the one managed by the bot.

## Improvements

This was later expanded to also show deals with a predefined amount of discount over official price and even later ([Ofertas25](https://t.me/ofertas25), [Ofertas50](https://t.me/ofertas50), [Ofertas70](https://t.me/ofertas70) ), a specific channel with only the prices that were LOWER than any other registered one at [Mínimos Históricos](https://t.me/minimos_historicos).

Additionally, the [bot](https://t.me/descuenbot), via a private message like `/ofertas add bluetooth` allows to forward you the deals that match your interest in `bluetooth` or any other topic, and also, allows excluding keywords not of your interest like `/ofertas add !headphones`. This allows to easily build a list of interests based on possitive and negative matches of the deals forwarded.

## The still existing problem

However, the amount of deals offered still contained a flaw: the actual discount price is based on Amazon API data, so if the seller puts an insanely high listing price and later shows as the actual price as a low one, it appears that product is highly discounted.

In order to avoid that, a new feature was added that keeps an average of prices, and enters into 'action' when at least 10 quotes have been obtained.

So, now, each product that gets checked on the API, gets new average calculated and each price (actual price) is compared against the average... if the actual price is higher than average, average gets updated and product is filtered out for everyone.

If the product instead get a lower price, it gets published as normal (like in above described [Mínimos Históricos](https://t.me/minimos_historicos)), BUT, if the product gets a lower price (higher than registered minimum), but still, lower than average (a real deal), it gets published as normal.

As a safety measure, the product is sent always if less than 10 quotes exist, allowing new products to be found and requiring a somewhat 'minimal' base before we can decide if it's a period for deals that makes it lower than usual or a product that regularly gets a fake hight listing price to simulate a high discount.

## Results obtained

I've captured a small table with some of the data processed so far

|    Day     | Removed posts |
| :--------: | :-----------: |
| 2020/01/01 |      52       |
| 2020/01/02 |      67       |
| 2020/01/03 |      151      |
| 2020/01/04 |      119      |
| 2020/01/05 |      245      |
| 2020/01/06 |      148      |
| 2020/01/07 |      300      |

Easy to explain, for those first days of the year, having more products with more than 10 samples, resulted in the number of posts 'removed' as those were `fake deals`.

In the end, linking with initial sentence... removing 'noise' from the communication, means better signal.

You can check the current list of channels maintained by the bot at <https://telegra.ph/Nuestros-canales-de-ofertas-06-21>

Enjoy
