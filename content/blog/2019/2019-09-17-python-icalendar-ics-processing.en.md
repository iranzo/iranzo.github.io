---
author: Pablo Iranzo Gómez
title: Python and iCalendar ICS processing
tags:
  - Python
  - Telegram
  - Linux
  - redken
  - ICS
  - calendar
  - webcal
layout: post
date: 2019-09-17 07:00:36 +0200
categories:
  - tech
  - python
  - redken_bot
description:
  This article covers  how to do Internet Calendar processing of events in
  python and how those are leveraged in @redken_bot
lang: en
modified: 2022-05-04T13:44:47.596Z
---

## Introduction

iCalendar (`.ics` or `webcal`) is a standard for providing 'calendar' information over text file, it allows to define events, etc and it's ideal to 'subscribe' over the internet to remote calendars, which is commonly used to show free/busy slots for scheduling meetings, etc.

If you're familiar with `Google Calendar` or others, it uses 'ics' under the hood, and you can get full url for it so that it can be shared.

I wanted to add ICS functionality to [@redken_bot](https://t.me/redken_bot) in Telegram, in a similar way to what I had for `RSS feeds`, `comic strips`, etc, so I started to investigate.

## The ICS file

The ICS file is a text-based file which contains some definitions for the `calendar` itself:

```ics
BEGIN:VCALENDAR
PRODID:-//Google Inc//Google Calendar 70.9054//EN
VERSION:2.0
CALSCALE:GREGORIAN
METHOD:PUBLISH
X-WR-CALNAME:Pablo
X-WR-TIMEZONE:Europe/Madrid
BEGIN:VTIMEZONE
TZID:America/Los_Angeles
X-LIC-LOCATION:America/Los_Angeles
BEGIN:DAYLIGHT
TZOFFSETFROM:-0800
TZOFFSETTO:-0700
TZNAME:PDT
DTSTART:19700308T020000
RRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=2SU
END:DAYLIGHT
BEGIN:STANDARD
TZOFFSETFROM:-0700
TZOFFSETTO:-0800
TZNAME:PST
DTSTART:19701101T020000
RRULE:FREQ=YEARLY;BYMONTH=11;BYDAY=1SU
END:STANDARD
END:VTIMEZONE
BEGIN:VTIMEZONE
TZID:Etc/UTC
X-LIC-LOCATION:Etc/UTC
BEGIN:STANDARD
TZOFFSETFROM:+0000
TZOFFSETTO:+0000
TZNAME:GMT
DTSTART:19700101T000000
END:STANDARD
END:VTIMEZONE
BEGIN:VTIMEZONE
TZID:Europe/Madrid
X-LIC-LOCATION:Europe/Madrid
BEGIN:DAYLIGHT
TZOFFSETFROM:+0100
TZOFFSETTO:+0200
TZNAME:CEST
DTSTART:19700329T020000
RRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU
END:DAYLIGHT
BEGIN:STANDARD
TZOFFSETFROM:+0200
TZOFFSETTO:+0100
TZNAME:CET
DTSTART:19701025T030000
RRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU
END:STANDARD
END:VTIMEZONE
BEGIN:VTIMEZONE
TZID:Europe/Paris
X-LIC-LOCATION:Europe/Paris
BEGIN:DAYLIGHT
TZOFFSETFROM:+0100
TZOFFSETTO:+0200
TZNAME:CEST
DTSTART:19700329T020000
RRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU
END:DAYLIGHT
BEGIN:STANDARD
TZOFFSETFROM:+0200
TZOFFSETTO:+0100
TZNAME:CET
DTSTART:19701025T030000
RRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU
END:STANDARD
END:VTIMEZONE
BEGIN:VTIMEZONE
TZID:Africa/Ceuta
X-LIC-LOCATION:Africa/Ceuta
BEGIN:DAYLIGHT
TZOFFSETFROM:+0100
TZOFFSETTO:+0200
TZNAME:CEST
DTSTART:19700329T020000
RRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU
END:DAYLIGHT
BEGIN:STANDARD
TZOFFSETFROM:+0200
TZOFFSETTO:+0100
TZNAME:CET
DTSTART:19701025T030000
RRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU
END:STANDARD
END:VTIMEZONE
```

And then, continues with the entries for the `events`:

```ical
BEGIN:VEVENT
DTSTART:20190928T100000Z
DTEND:20190928T150000Z
DTSTAMP:20190917T013736Z
ORGANIZER;CN=YOURCOMMONNAME:mailto:YOUREMAIL
UID:47chc1nab6lih8jtjs3o38mtio@google.com
ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;CN=CONTACTNAME;X-NUM-GUESTS=0:mailto:CONTACTEMAIL
CREATED:20190914T204615Z
DESCRIPTION:
LAST-MODIFIED:20190915T211230Z
LOCATION:LOCATIONFOREVENT
SEQUENCE:0
STATUS:CONFIRMED
SUMMARY:EVENTSUMMARY
TRANSP:OPAQUE
END:VEVENT
```

In this case, we can see that there's an event starting on 28th September 2019, which lasts 5 hours in 'GMT' which also defines attendees (to get confirmations of assistance, etc), event location (so that you can click and use your maps app to 'navigate' to it, etc)

## Python processing

After some research (and trial-error), I found that `icalendar` library allowed to process the entries in a `simple` way:

```py
# coding: utf-8
from datetime import datetime
from datetime import timedelta

import requests
from icalendar import Calendar, Event, vDatetime
from pytz import timezone

tz = timezone('Europe/Madrid')

calendar = 'http://www.webcal.fi/cal.php?id=191&format=ics&wrn=1&wp=4&wf=53&color=%23FF3100&cntr=es&lang=es&rid=wc'

# Just in case we want to get calendar for another day
date = (datetime.now() + timedelta(days=0))
datefor = "%s" % date.strftime('%Y-%m-%d')

r = requests.get(calendar)
# We use the library to 'read' the url contents (text output)
gcal = Calendar.from_ical(r.text)

# walk the 'VEVENTS'
for event in gcal.walk('VEVENT'):
    # Get 'start' date
    if 'DTSTART' in event:
        try:
            dtstart = event['DTSTART'].dt.astimezone(timezone('Europe/Madrid'))
        except:
            dtstart = False

    # Get 'stop' date
    if 'DTEND' in event:
        try:
            dtend = event['DTEND'].dt.astimezone(timezone('Europe/Madrid'))
        except:
            dtend = False

    # If we've dtstart or tend, print event information
    if dtstart or dtend:
        # This find current date (year-month-day) in the dtstart or dtend in the event for printing it
        if datefor in "%s" % dtstart or datefor in "%s" % dtend:
            print("\n📅", event['summary'])

            if dtstart and dtend:
                lenght = (dtend - dtstart).total_seconds()/60
            else:
                lenght = False

            if lenght:
                print("🕑 start: %s for %s minutes" % (dtstart, lenght))
```

This code was working fine, but my calendar have several events that are recurring, hence, start date or end date is not 'today', which was causing a problem, as I was getting the events for today (started/stopped), but not the recurring ones that were having 'an iteration' today.

After some more research, I found that `dateutil` library contains `rrule` which allows to process another field in the events:

```ical
BEGIN:VEVENT
DTSTART;TZID=Europe/Madrid:20190903T170000
DTEND;TZID=Europe/Madrid:20190903T174500
RRULE:FREQ=WEEKLY;WKST=MO;BYDAY=TH,TU
DTSTAMP:20190917T013736Z
ORGANIZER;CN=YOURNAME:mailto:GROUPEMAIL
UID:3rhualb4j1kl2jdpemsd39o668@google.com
ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=ACCEPTED;CN=ATTENDEENAME;X-NUM-GUESTS=0:mailto:ATTENDEEMAIL
CREATED:20190617T073502Z
DESCRIPTION:
LAST-MODIFIED:20190902T105136Z
LOCATION:EVENTLOCATION
SEQUENCE:0
STATUS:CONFIRMED
SUMMARY:EVENT SUMMARY
TRANSP:OPAQUE
END:VEVENT
```

This event, starts and ends on 3rd September, so in the above code it was not showing, however, we can see that it has a `RRULE` field which says that happens weekly, with repeating days on Thursdays and Tuesdays.

`Rrule` allows to process it:

```py
# <snip>

import dateutil.rrule as rrule

if 'RRULE' in event:
    # This gets the rule as 'string' so that it can be processed
    ruletext = event['RRULE'].to_ical().decode()

    # This defines the rule object, with the rule text and using the initial date for the event
    rule = rrule.rrulestr(ruletext, dtstart=event['DTSTART'].dt)

    # This is the interesting part, where, based on actual date and rule for repetition, calculates 'next' occurrence for the event
    nextrule=rule.after(datetime.now().astimezone(timezone('Europe/Madrid')))
# <snip>
```

## Wrapping-it-up

So, with the above process 'in place', the final code is similar to this:

```py
# coding: utf-8
from datetime import datetime
from datetime import timedelta

import requests
from icalendar import Calendar, Event, vDatetime
from pytz import timezone
import dateutil.rrule as rrule

format = "%Y-%m-%d %H:%M:%S %Z%z"

tz = timezone('Europe/Madrid')

calendars = []
calendars.append(
    'http://www.webcal.fi/cal.php?id=191&format=ics&wrn=1&wp=4&wf=53&color=%23FF3100&cntr=es&lang=es&rid=wc')


date = (datetime.now() + timedelta(days=0))
datefor = "%s" % date.strftime('%Y-%m-%d')

for calendar in calendars:
    r = requests.get(calendar)
    gcal = Calendar.from_ical(r.text)

    for event in gcal.walk('VEVENT'):
        if 'DTSTART' in event:
            try:
                dtstart = event['DTSTART'].dt.astimezone(timezone('Europe/Madrid'))
            except:
                dtstart = False
        if 'DTEND' in event:
            try:
                dtend = event['DTEND'].dt.astimezone(timezone('Europe/Madrid'))
            except:
                dtend = False
        if 'RRULE' in event:
            try:
                ruletext = event['RRULE'].to_ical().decode()
                rule = rrule.rrulestr(ruletext, dtstart=event['DTSTART'].dt)
                nextrule=rule.after(date.astimezone(timezone('Europe/Madrid')))
            except:
                nextrule = False
        else:
            nextrule = False

        if dtstart or dtend or nextrule:
            if datefor in "%s" % dtstart or datefor in "%s" % dtend or datefor in "%s" % nextrule:
                print("\n📅", event['summary'])

                if dtstart and dtend:
                    lenght = (dtend - dtstart).total_seconds()/60
                else:
                    lenght = False

                if not nextrule:
                    if lenght:
                        print("🕑 start: %s for %s minutes" % (dtstart, lenght))
                else:
                    print("🕑 start: %s for %s minutes" % (nextrule, lenght))
```

This code is still not complete, as it for sure, lists 'single' events happening today, or 'recurring' events happening also today, but it doesn't take into consideration 'Excludes' to those rules, like for example, when a recurring event is cancelled for a specific date, etc.

However, for a first iteration, code works and now the [@redken_bot](https://t.me/redken_bot) can also remind you on your day events on multiple calendars :)
