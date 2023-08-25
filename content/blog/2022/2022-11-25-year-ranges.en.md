---
author: Pablo Iranzo Gómez
tags:
  - tech
  - Tips
  - Python
  - FOSS
title: "[python] Generate ranges from items"
categories:
  - tech
date: 2022-11-25T07:00:46.350Z
lastmod: 2023-08-25T09:46:05.335Z
---

Some years ago, I added a script for updating headers for `(C)` in the python files I was developing for [Risu]({{< relref "/tags/risu" >}}).

In this way, the header got the list of authors and years working on the files updated automatically.

With the pass of the years, the list started to became a bit too long, so I worked on creating code for getting ranges instead.

This is the code I used:

```py
def getranges(data):
    """
    From list of strings representing numbers, get ranges and return list of strings
    :param data: list of strings representing numbers
    :return: list of strings with number ranges when > 1
    """

    # Convert to integers
    data = [int(i) for i in data]

    result = []
    if not data:
        return result

    # Prepare iteration loop
    idata = iter(data)
    first = prev = next(idata)
    first = first
    prev = prev

    # Process next item
    for following in idata:
        if following - prev == 1:
            # Years are continuum, just update previous
            prev = following
        else:
            # Years are not continuum, end range and start again
            if first == prev:
                result.append(first)
            else:
                if first + 1 == prev:
                    # Only one item in difference, append items individually
                    result.append(first)
                    result.append(prev)
                else:
                    result.append("%s-%s" % (first, prev))
            first = prev = following

    # Catchall for regular execution or last remaining range

    if first == prev:
        result.append(first)
    else:
        if first + 1 == prev:
            # Only one item in difference, append items individually
            result.append(first)
            result.append(prev)
        else:
            result.append("%s-%s" % (first, prev))

    # Convert back to text
    result = [str(i) for i in result]
    return result
```

With it, previous headers like:

```
# Copyright (C) 2018, 2019, 2020, 2021, 2022 Pablo Iranzo Gómez <Pablo.Iranzo@gmail.com>
```

Now appear as:

```
# Copyright (C) 2018-2022 Pablo Iranzo Gómez <Pablo.Iranzo@gmail.com>
```

{{<enjoy>}}
