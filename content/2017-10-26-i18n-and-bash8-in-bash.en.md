---
layout: post
title: i18n and 'bash8' in bash
date: 2017-10-26 21:17:00 +0200
comments: true
tags: bash, gettext, i18n, Citellus, bashate, FOSS
category: tech
description:
---

[TOC]

## Introduction

In order to improve [Citellus]({filename}2017-07-26-Citellus-framework-for-detecting-known-issues.en.md) and [Magui]({filename}2017-07-31-Magui-for-analysis-of-issues-across-several-hosts.en.md), we did implement some [Unit testing]({filename}2017-08-17-Jenkins-for-running-CI-tests.en.md) to improve code quality.

The tests written were made in python and with some changes it was also possible to validate the actual tests.

Also, we did prepare the strings in python using gettext library so the actual messages can be translated to the language of choice (defaults to en, but can be changed via `--lang` modifier of citellus).

## Bashate for bash code validation

One of the things I did miss was to have some kind of `tox8` for validate format, and locate some errors. After some research I came to
[`bashate`](https://github.com/openstack-dev/bashate), and as it was written in python was very easy to integrate:

- Update `test-requirements.txt` to request bashate for 'tests'
- Editing `tox.ini` to add a new section

  ```ini
  [testenv:bashate]
  commands =
      bash -c 'find citellus -name "*.sh" -type f -print0 | xargs -0 bashate -i E006'
  ```

This change makes that execution of `tox` also pulls the output of bashate so all the integration already done for CI, was automatically update to do bash formatting too :-)

## Bash i18n

Another topic that was interesting is the ability to easily write code in one language and via `poedit` or equivalent editors, be able to localize it.

In python is more or less easy as we did for citellus code, but I wasn't aware of any way of doing that for bash scripts (such as the plugins we do use for citellus).

Doing a simple `man bash` gives some hints somewhat hidden:

```
--dump-po-strings
    Equivalent to -D, but the output is in the GNU gettext po (portable object) file format.
```

So, bash has a way to dump `po` strings (to be edited with `poedit` or your editor of choice), so only a bit more search was required to find how to really do it.

Apparently is a lot easier than I expected, as long as we take some considerations:

- LANG shouldn't be `C` as it disables i18n
- Environment variable `TEXTDOMAIN` should indicate the filename containing the translated strings.
- Environment variable `TEXTDOMAINDIR` should contain the path to the root of the folder containing the translations, for example:
  - `TEXTDOMAIN=citellus/locale`
  - And language file for `en` as:
    - `citellus/locale/en/LC_MESSAGES/$TEXTDOMAIN.mo`

Now, the "trickier" part was to prepare scripts...

```sh
# Legacy way
echo "String"
# i18n way
echo $"String"
# Difficult... isn't it?
```

This change makes 'bash' to lock for the string inside `$TEXTDOMAINDIR/locale/$LANG/LC_MESSAGES/$TEXTDOMAIN.mo` and do on the fly replacement of the strings for the translated ones (or fallback to the one echoed).

In citellus we did implement it by exporting the extra variables defined above, so scripts, as well as framework is ready for translation!.

Just in case, some remarks:

- I found some complains when same script outputs the same string in several places, what I did, is to create a VAR and echo that var.

- As we've strings in citellus.py, magui.py, etc and the bash files, I did update a script to extract the required strings:

```sh
# Extract python strings
python setup.py extract_messages -F babel.cfg -k _L
# Extract bash strings
find citellus -name "*.sh" -exec bash --dump-po-strings "{}" \; > citellus/locale/citellus-plugins.pot
# Merge bash and python strings
msgcat -F citellus/locale/citellus.pot citellus/locale/citellus-plugins.pot > citellus/locale/citellus-new.pot
# Move file to destination
cat citellus/locale/citellus-new.pot > citellus/locale/citellus.pot
```

In this way, we're ready to use on editor to translate all the strings for the whole citellus + plugins.

Enjoy!
