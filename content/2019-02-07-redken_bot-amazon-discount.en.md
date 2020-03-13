---
author: Pablo Iranzo Gómez
title: Telegram Redken bot and amazon/discounts/bargains unification
tags: FOSS, Telegram, Python, Amazon, programming, redken
layout: post
date: 2019-02-07 21:04:14 +0100
comments: true
category: tech
description:
---

[TOC]

# Introduction

During last years of increased Telegram adoption among contacts, [the low learning curve to write bots]({filename}2015-06-26-writing-a-telegram-dot-org-bot-in-python.en.md) for it as well as the capacity of bigger group chats and 'channels' for one-way publishing of information has helped the proliferation of 'bargain' groups.

In those groups, there are 'discounts', 'sales', about any range of products you can imagine (clothing, shoes, toys, mobiles, tv's, beauty, etc).

From those groups I was able to get good deals, even sometimes, some elements were 'for free' via usage of coupon codes, etc.

Bad side, is that number of channels have evolved beyond control, and made the telegram client become a source of 'noise' versus a source of information.

Of course, the biggest issue is that many of those channels are providing the same 'information' sometimes but not always the same, and even if there are some 'theme' channels, it's not uncommon to see offers that might not suite your needs in the biggest categories (for example you want a mobile but you're getting all offers about 'tech' stuff, or you want 'lego' and you get lot of other toys or kids-things).

# Python to the rescue

Using python we can come to approach this in several steps:

- First we can expand the url to longer one (those channels tend to use url shorteners)

```py
def expandurl(url):
"""
Expands short URL to long one
:param url: url to expand
:return: expanded url
"""

logger = logging.getLogger(__name__)

try:
    session = requests.Session()  # so connections are recycled
    resp = session.head(url, allow_redirects=True, timeout=10)
    newurl = resp.url
    logger.debug(msg="URL Expanded to: %s" % newurl)
except:
    # Fake as we couldn't expand url
    newurl = url

logger.debug(msg="Expanding url: %s to %s" % (url, newurl))

return newurl
```

- Second, restrict the links we process to the ones in amazon, as it's 'easy' to catch the product ID and perform a search. This leaves out lot of offers, but makes it easier to locate them as there's an API to use.

```py
def findamazonproductid(newurl):
    """
    Finds amazon product id and country in URL
    :param newurl: url to parse
    :return: productid, country
    """
    domain = None

    # Find Product ID in URL
    prodregex = re.compile(r"\/([A-Z0-9]{10})")
    r = prodregex.search(newurl)

    if r:
        productid = r.groups()[0]
    else:
        productid = None

    domainregex = re.compile(r"amazon\.([a-z0-9\.]{1,5})/")
    r = domainregex.search(newurl)
    if r:
        domain = r.groups()[0]

    return productid, domain
```

- Now that we get product id an domain, we can use a database to store when was received (if before) and store as 'seen' to not repeat it.

Telegram bot API can help sending the messages or receiving them from a chat, so now it is our chance to code in the way we want it.

Additionally, python packages like [python-amazon-simple-product-api](https://github.com/yoavaviram/python-amazon-simple-product-api), with some simple steps, can help enhancing the database by querying additional details.

```py
from amazon.api import AmazonAPI
amazon = AmazonAPI(amazon_access, amazon_key, tag, region=regdomain
product = amazon.lookup(ItemId=productid)
```

Above code with the `productid` obtained in the previous code snippet, allows us to query several aspects via amazon api, like `product.title`, `product.price_and_currency`, etc

# Building the solution

Ok, we've seen what is needed to expand url, get product id from it and then how to use amazon to get product price, title, etc.

In my case, the next step was to get rid of unwanted offers, but once I had all the data above, it was not difficult to reuse the ['highlight'](https://github.com/iranzo/stampython/blob/master/stampy/plugin/highlight.py) module in <https://t.me/redken_bot> to forward the products matching the words I wanted to track.

A global replace from `hilight` to `ofertas`, adding a few comparisons for `gofertas` and now redken supports the following syntax:

```
# Add tracking for a word in discounts
/gofertas add <topic>
/ofertas add <topic>

# Remove tracking for a word in discounts
/[g]ofertas delete topic

# Get list of configured discoints
/[g]ofertas list
```

The difference between `gofertas` and `ofertas`, is that by default, `ofertas` adds the tracking to your `userid`, hence forwarding privately to you, while `gofertas`, when used on a group, will forward to the `groupid`, allowing for example that users interested in a topic, like let's say `Lego` or `quadricopters`, will receive as a group message any new listing published.

Enjoy and happy filtering!

Follow telegram channels managed by bot at: <https://telegra.ph/Nuestros-canales-de-ofertas-06-21>
