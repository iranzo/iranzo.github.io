---
author: Pablo Iranzo Gómez
title: API access for Google Calendar and Google Sheet access
tags:
  - Google calendar
  - Google sheets
  - spreadsheet
  - ics
  - calendar
  - python
  - foss
layout: post
date: 2019-11-28 17:11:36 +0100
categories:
  - tech
  - python
  - redken_bot
lang: en
lastmod: 2023-08-25T09:48:47.219Z
---

## Introduction

During last days I've been playing around with python and API access to Google Sheets.

Since some time ago, I already experimented with ICS parsing from python because added https://t.me/redken_bot access to calendar files (`.ics`) so that it can provide daily reminders on chats about the events happening for the specific date, and had the chance to propose it's usage to cover a specific use case: Accessing a spreadsheet in Google Sheets and parse its contents and output an ICS file so that the events listed and the dates specific for each one are available in an easier-to-consume approach.

## Accessing Google Sheets

Doing some research, it seemed that `gspread` python library was the easiest one to get the access to the spread sheet and then be able to process it.

Access requires setting up a `credentials.json` that is created using the [Google developers console](https://console.developers.google.com/) (we should create a new project, create new credentials, etc). Please, read [gspread documentation](https://gspread.readthedocs.io/en/latest/oauth2.html) on requisites and steps for obtaining this file.

Once the file is there, the code can be as easy as:

```py
import os
import gspread
from oauth2client.service_account import ServiceAccountCredentials

# use creds to create a client to interact with the Google Drive API
scope = [
    "https://spreadsheets.google.com/feeds",
    "https://www.googleapis.com/auth/drive",
]
creds = ServiceAccountCredentials.from_json_keyfile_name(
    os.environ["GACREDENTIALS"], scope
)
client = gspread.authorize(creds)

# Find a workbook by name and open the first sheet
# Make sure you use the right name here.
sheet = client.open("My spreadsheet").sheet1

# Extract and print all of the values
records = sheet.get_all_records()

for record in records:
    if record["name"] != "":
        dosomething()
```

In this case, we access the file via the file pointed in `GACREDENTIALS` environment variable and use the scope for defining the access level we need for this file.

In this case, the spreadsheet was shared with 'viewer' permissions to the system account created for the credentials and stored in the file on disk.

This enabled us to iterate over the elements and parse the rows in the sheet for doing or 'ICS' dump to file, using specific column for each item (start date, end date, description, location, name, etc)

The generated ICS file could be stored in an accessible Webserver for subscribing to it, or we could manually import the events into our calendar.

This solution, however, created duplicates of entries on each import, as the walk process just recreated all the entries on each execution.

As a next-step, it was considered to directly write them to Google calendar so that the file itself could be created and stored but the actual event check happening via regular calendaring app.

## Accessing Google Calendar

Access to Google calendar required to setup another method for accessing via using the standard [Google API for Python](https://developers.google.com/calendar/quickstart/python). This required to setup credentials for OAUTH app, with a 'portal' to grant access to a user, which writes a token to disk that can later be used for accessing the service.

As we're reading always from the same Google Sheet, we wanted to first cleanup the older entries, so we used the following code (taken from: <https://karenapp.io/articles/2019/07/how-to-automate-google-calendar-with-python-using-the-calendar-api/>):

```py
import os
import os.path
import pickle
import sys

import dateutil.parser
import gspread
from google.auth.transport.requests import Request
from googleapiclient.discovery import build
from oauth2client.service_account import ServiceAccountCredentials

# If modifying these scopes, delete the file token.pickle.
SCOPES = ["https://www.googleapis.com/auth/calendar"]

credpickle = os.environ["GApickle"]

# Calendar to write to
mycalendarid = "mycalendarID received when listing available calendars"


def get_calendar_service():
    """
    Gets calendar service handler
    :return: services handler
    """
    creds = None
    # The file token.pickle stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    if os.path.exists(credpickle):
        with open(credpickle, "rb") as token:
            creds = pickle.load(token)

    # If there are no (valid) credentials available, FAIL!
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            print("Error, create a new pickle file for continuing")
            sys.exit(1)

        # Save the credentials for the next run
        with open("token.pickle", "wb") as token:
            pickle.dump(creds, token)

    service = build("calendar", "v3", credentials=creds)
    return service
```

We also wrote a function for writing new events to the calendar:

```py
def writeevent(service, summary, location, start, end, description):
    """
    Writes event to Gcal
    :param service: service handler
    :param summary: summary of event
    :param location: location of event
    :param start: start date
    :param end: end date
    :param description: Description of event
    """

    event_result = (
        service.events()
        .insert(
            calendarId=mycalendarid,
            body={
                "summary": summary,
                "location": location,
                "start": {
                    "date": start.strftime("%Y-%m-%d"),
                    "timeZone": "Europe/Madrid",
                },
                "end": {
                    "date": end.strftime("%Y-%m-%d"),
                    "timeZone": "Europe/Madrid",
                },
                "description": description,
            },
        )
        .execute()
    )
    print("Event: %s written" % summary)
```

And the main code:

```py
def main():
    """
    Main code for the program
    """

    # Cleanup Gcalendar
    service = get_calendar_service()

    # Call the Calendar API
    events_result = service.events().list(calendarId=mycalendarid).execute()
    events = events_result.get("items", [])

    # Delete all the events
    for event in events:
        try:
            print("Deleting event: %s" % event["summary"])
            service.events().delete(
                calendarId=mycalendarid, eventId=event["id"]
            ).execute()
        except googleapiclient.errors.HttpError:
            print("Failed to delete event")

    # Create events

    # Connect to Gspreadsheet to get events
    # use creds to create a client to interact with the Google Drive API
    scope = [
        "https://spreadsheets.google.com/feeds",
        "https://www.googleapis.com/auth/drive",
    ]
    creds = ServiceAccountCredentials.from_json_keyfile_name(
        os.environ["GACREDENTIALS"], scope
    )
    client = gspread.authorize(creds)

    # Find a workbook by name and open the first sheet
    # Make sure you use the right name here.
    sheet = client.open("KNI conferences pipeline").sheet1

    # Extract and print all of the values
    records = sheet.get_all_records()

    # Iterate records for valid events and create them
    for record in records:
        if record["Name"] != "":
            # Main event
            start = record["Starts"]
            end = record["Ends"]
            startdate = False
            enddate = False

            if start != "":
                startdate = dateutil.parser.parse(start)

            if end != "":
                enddate = dateutil.parser.parse(end)

            if startdate and enddate:
                writeevent(
                    service,
                    summary=record["Conference"],
                    location=record["Location"],
                    start=startdate,
                    end=enddate,
                    description=record["Event URL"],
                )


if __name__ == "__main__":
    main()
```

## Wrap up

The final code, is able to use both API's to get access to the spreadsheet, read the rows, and in parallel use the API to `nuke` the calendar, by removing all events and then, recreating them with the data obtained from the spreadsheet.

There's of course room for optimization, like just updating events if it's changing or not, but that would make code more complex and not adding much more functionality (as still calls would be needed for querying event, comparing, and then updating as needed).

{{<note>}}

If you wonder about why using environment variables for the credential files used... this jobs runs inside Jenkins instance that has the defined secrets exported in the Jenkinsfile as environment variables, allowing to 'secure' a bit more the access to the credentials itself (even if those have been scope-limited to only allow not harmful usage.)
{{</note>}}

{{<enjoy>}}
