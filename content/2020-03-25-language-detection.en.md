---
author: Pablo Iranzo Gómez
title: Language detection in @redken_bot
tags: English, language, python, foss, telegram
layout: post
date: 2020-03-25 20:00:24 +0100
comments: true
category: blog
description:
lang: en
---

[TOC]

## Introduction

Before the move to Python3, [redken](https://t.me/redken_bot) had per-group language configuration by using i18n, with the upgrade/rewrite of Python3 code there were some issues and I had to remove the support, defaulting everything to English (most of the outputs where already in English so not a great loss).

On another side, having to manually configure each channel could be problematic as most users just add the bot to their groups but don't care about other settings that might be useful like `welcome` message, `inactivity` for kicking out inactive users, etc.

## Telegram's approach

Initial version was added by expanding regular function that processes the Telegram-Server message to also take consideration of the user-indicated language and use that to store a new field in the database with the language, but that came with problems:

- Not all users had the language configured, so most times it was ""
- When talking on a group, the `id` was the group one, so if a user had language set to something and then other user wrote on the chat, it was just storing the 'last used' language interface.

## Python to the rescue

As the bot is written in Python, I did a quick search for language detection and found [`langdetect`](https://github.com/Mimino666/langdetect) which is a port of a Java library to Python that can find certain words, etc in the texts and give some hint about the language.

So, instead of using the almost-always-empty user defined language for the interface, it started using `langdetect` for getting the message language based on the text.

This of course, solved on of the problems (no-configured language by users), still left the one on the 'last-language-used' and introduced a new one:

- `langdetect` does a guess based on common words, accents, characters, etc but it's just that: a guess.

The approach then was to use something that was introduced in [@descuenbot](https://t.me/descuenbot) and was described in [this article]({filename}2020-01-07-new-features-in-descuenbot.en.md): calculate averages based on prior count and new value.

In this way, the language moved from being just a string to become a dictionary, storing `count` and `lang: %` values, for example:

```py
{"count": 272, "en": 2.2, "es": 75.36, "it": 3.74, "ca": 3.48, "fi": 2.3, "fr": 1.64, "pt": 1.73, "et": 0.97, "ro": 0.68, "de": 1.11, "hr": 0.68, "sw": 1.09, "tl": 0.96, "lt": 0.68, "sk": 1.22, "so": 1.16, "da": 1.18, "sv": 0.67, "tr": 0.58, "hu": 0.46, "vi": 0.43, "sl": 0.41, "no": 0.37}
```

This is my status, from 272 messages, the library has detected Spanish 75% of times, plus some other messages. As you might infer, there are lot of languages listed there that I never used, so it's really important to keep this values refreshing with higher message counts.

For groups, this becomes even more interesting, as the message languages get updates for each user that speaks in the channel, giving 'faster', good results on the language being used:

English group:

```py
{"count": 56, "tr": 1.79, "en": 80.36, "da": 1.79, "af": 1.79, "sl": 1.79, "ca": 1.79, "es": 1.79, "fi": 1.79, "nl": 1.79, "it": 1.79, "sq": 1.79, "so": 1.79}
```

Spanish group:

```py
{"count": 140, "es": 61.42, "fi": 0.68, "ca": 1.46, "it": 5.72, "tr": 0.68, "sw": 1.46, "pt": 5.74, "so": 2.12, "en": 8.58, "pl": 0.68, "sv": 1.48, "hr": 0.68, "sk": 0.67, "cy": 3.58, "tl": 1.43, "sl": 0.68, "no": 1.44, "de": 0.69, "da": 0.7}
```

Of course, before integrating this code into [@redken_bot](https://t.me/redken_bot), I did a small program to validate it:

```py
from langdetect import detect
import json

# Add some sentences to an array to test
text = []
text.append("It could be that your new system is not getting as much throughput to your hard disks as it should be")
text.append("Il mio machina e piu veloce",)
text.append("Je suis tres desolè",)
text.append("El caballo blando de santiago era blanco",)
text.append("My tailor is rich",)
text.append("En un lugar de la Mancha de cuyo nombre no quiero acordarme",)
text.append("Good morning, hello, good morning hello")
text.append("No es cierto angel de amor que en esta apartada orilla no luce el sol sino brilla")
text.append("Tears will be falling under the heavy rain")
text.append("Que'l heure est il?")
text.append("Caracol, col col, saca los cuernos al sol")


# Create dictionary empty for this to work
language = {}
language["count"] = 0

# Process each line in text
for line in text:
    # As we'll be iterating later over a dictionary, prepare updates in a different one
    updates = {}

    # Detec language in the line received
    language_code = detect(line)

    print(" ")
    print("Processing Line with detected language ", language_code, "|", line)

    updates["count"] = language["count"] + 1

    # Check if we need to add key to language
    if language_code not in language:
        print("New key in language, preparing updates")
        # New language % is 100 over the total number of updates received before, so 100% for the first message in a group
        updates[language_code] = 100 / updates["count"]

    # Process each key we already had in language
    for key in language:
        # If the new language matches the one detected, give it a 100%, else, 0% , so that we work on % for each language
        if key == language_code:
            value = 100
        else:
            value =0

        # As we store message count in the same dictionary, we just skip it
        if key != "count" :

            print("Processing key %s in language for average updates" % key)
            updates[key] = float("{0:.2f}".format(language[key] + ((value - language[key]) / updates["count"])))
            print("New average: %s for language %s" % (updates[key], key))

    print("Updates: %s" % updates)
    language.update(updates)

    print(language)

    # Validate that final sum of % is close to 100% (consider rounding problems)
    accum = 0
    for key in language:
        if key != 'count':
            accum = accum + language[key]

    print(float("{0:.2f}".format(accum)))

# Dump the json of the final detected languages
print(json.dumps(language))
```

Which, when executed, gives as final results:

```sh
Processing Line with detected language  fr | Que'l heure est il?
Processing key en in language for average updates
New average: 40.0 for language en
Processing key it in language for average updates
New average: 10.0 for language it
Processing key fr in language for average updates
New average: 20.0 for language fr
Processing key es in language for average updates
New average: 30.0 for language es
Updates: {'count': 10, 'en': 40.0, 'it': 10.0, 'fr': 20.0, 'es': 30.0}
{'count': 10, 'en': 40.0, 'it': 10.0, 'fr': 20.0, 'es': 30.0}
100.0

Processing Line with detected language  es | Caracol, col col, saca los cuernos al sol
Processing key en in language for average updates
New average: 36.36 for language en
Processing key it in language for average updates
New average: 9.09 for language it
Processing key fr in language for average updates
New average: 18.18 for language fr
Processing key es in language for average updates
New average: 36.36 for language es
Updates: {'count': 11, 'en': 36.36, 'it': 9.09, 'fr': 18.18, 'es': 36.36}
{'count': 11, 'en': 36.36, 'it': 9.09, 'fr': 18.18, 'es': 36.36}
99.99
{"count": 11, "en": 36.36, "it": 9.09, "fr": 18.18, "es": 36.36}
```

## Conclusion

Above code was adapted to redken, so when a new user message was received, both the group when the user wrote a sentence and the user itself, got a new dictionary of languages detected.

This approach, of using the 'moving %', just requires prior value for language and items count to calculate the new one reducing both the information needed to be stored to a minimum.

In the future, when I'm adding back strings for languages, I can automate how redken reacts per channel (unless overridden) so that it provides messages in a more natural way for users.

Enjoy!
