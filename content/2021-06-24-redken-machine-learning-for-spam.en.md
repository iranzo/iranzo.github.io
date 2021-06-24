---
author: Pablo Iranzo Gómez
title: Redken machine learning for spam detection
tags: FOSS, Telegram, Python, programming, redken, scikit, machine learning, ML
layout: post
date: 2021-06-24 22:00:00 +0200
comments: true
category: tech
description:
---

[TOC]

For some of the telegram groups I'm in, I've been detecting users that after some period of time, just publish spam messages of any topic.

There are many bots for controlling when a user joins, by showing a CAPTCHA that user must resolve (either clicking a button, answering a mathematical operation, inputting a CAPTCHA image text, etc).

Some time ago, a colleague was using Machine Learning and I wanted to have a look at it and it would make a good feature to implement.

First thing I wanted, was to get rid of the spammers, so the first approach was to include a new command on [redken_bot](https://t.me/redken_bot) to mark with `/spam` when replying to a message to take some actions.

The `/spam` command also required some protection from abuse, so it should only work for admins.

# The admin detection

In the beginning some of the commands added to [redken_bot](https://t.me/redken_bot) had admin access that required the user to define the list of administrators via the `admin` configuration variable... but no one did.

With some changes in the telegram BOT API, the bot can get (when added as one of the admins in your group) the membership permission updates, so when a membership update arrives (new user added as admin or admin user becoming regular user), the bot will call the function to refresh the list of administrators and use it to update the `admin` variable automatically.

This required changing the way calls were made to get new telegram updates, but I enabled all the possible types of messages, as well as rewriting the function processing the data out of each message, but was a good improvement (even if invisible for outside users.)

# Spam actions

Once the admin detection was solved and running (bot currently is member of 549 groups and has 28252 unique users, and only 20 groups have the admin variable set), the next step was to work on the spam actions.

Many times I was manually doing the stuff:

- Deleting message
- Kicking user and reporting as spam
- Sometimes even noting user UID to add to a blocklist

So I decided to create a new command `/spam` which automates part of the job:

- Deletes message
- Stores UID in the database as spammer
- Kicks user out of the chat

# Buttons for easier usage

It would be great to have automatic detection, and easier reporting, so next step was playing a bit with buttons.

To be honest, never used them except for some attempts, but as I was playing with updated messages for the `admin` stuff, so was worth to use the feature that was there to add extra parameters to the call.

```py
yes = "Yes"
no = "No"
ignore = "Ignore"
isthisspammsg = "Is this spam?"

extra = (
        'reply_markup={"inline_keyboard":[[{"text":"%s","callback_data":"SPAM"},{"text":"%s","callback_data":"HAM"},{"text":"%s","callback_data":"IGNORE"}]]}'
        % (yes, no, ignore)
    )
```

With above approach, the bot could reply to messages and attach an inline-keyboard with configurable buttons, returning as part of the callback data the message I wanted (`HAM`,`SPAM` or `IGNORE`).

This, also required to process the `callback_data` that we were now collecting since the changes added for the admin status change.

The good thing is that the answer provided when pressing the button, contains reference to the original message, so it was easier to later catch the text we were replying with the buttons.

# Machine learning

Machine learning more or less, is showing data to an algorithm with results tagged in one or either way, divide the set of data between a training group and a test group and feed it to the algorithm to find how good it has been.

For doing so, it converts the input data into numbers and tries to find relationships between them. This also opens the pandora box as it has lot of different approaches, depending on the function being used for doing the conversion, for example, some of them use frequency of elements, removing the less frequent, etc

Finally, using the model the program can classify new data, based on the model that was elaborated, and in order to improve it, the data should be refreshed with new patterns for both cases: ham and spam so that it can continue evolving.

There are lot of documents about this, the shortest example I can think of is:

```py
from langdetect import detect
from nltk.corpus import stopwords
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfTransformer
from sklearn.metrics import classification_report, confusion_matrix, accuracy_score
from sklearn.model_selection import train_test_split
from sklearn.naive_bayes import MultinomialNB
from sklearn.pipeline import Pipeline
import logging
import nltk
import os
import pandas as pd
import pickle
import dill
import string
import sys

logger = logging.getLogger(__name__)

logger.debug("Downloading updated stopwords")
nltk.download("stopwords")

    job

logger.debug("Starting training with on-disk databases")
message = pd.read_csv(
        "spam/spam.%s.csv" % language, sep=",", names=["Category", "Message"]
    )

# Drop duplicate messages
message.drop_duplicates(inplace=True)

# Split the messages between train and test
msg_train, msg_test, label_train, label_test = train_test_split(
    message["Message"], message["Category"], test_size=0.2
)

# Define the function for our language

pipeline = Pipeline(
    [
        (
            "bow",
            CountVectorizer(
                analyzer=lambda text: process_text(
                    text, language=languages[language]
                )
            ),
        ),
        ("tfidf", TfidfTransformer()),
        ("classifier", MultinomialNB()),
    ]
)
logger.debug("Training the algorithm for language: %s" % language)
pipeline.fit(msg_train, label_train)

# Evaluate the model on the training data set
print("Testing the training for language: %s" % language)

pred = pipeline.predict(msg_train)
logger.debug("Accuracy with train data")
logger.debug("%s" % classification_report(label_train, pred))
logger.debug("Confusion Matrix:\n%s" % confusion_matrix(label_train, pred))
logger.debug("Accuracy: %s" % accuracy_score(label_train, pred))

pred = pipeline.predict(msg_test)
logger.debug("Accuracy with test data")
logger.debug("%s" % classification_report(label_test, pred))
logger.debug("Confusion Matrix:\n%s" % confusion_matrix(label_test, pred))

accuracy = accuracy_score(label_test, pred)
logger.debug("Accuracy: %s" % accuracy)
```

In short, this loads a know list of messages with spam and ham and divides it to train the model (via the pipeline) and later to test on the test data to check accuracy.

For doing so, it also downloads `stopwords`, which allows to remove junctions from phrases that are usually less meaningful of the message data itself. The `process_text` function defined in the pipeline is the one that we should write and takes care of removing punctuation, stopwords, etc.

Of course, training takes a while so it's not something you'll be doing in realtime, but there is where the `dill` library (that worked better for my use case than `pickle`) helped me... Bot trains every day for new language model, stores it on disk, and later is able to restore from disk and directly use it.

For saving and restoring we can use something like this:

```py
# Save trained pipeline
with open(pkl_filename, "wb") as file:
    dill.dump(pipeline, file)

# Restore trained pipeline
with open(pkl_filename, "rb") as file:
    pipeline = dill.load(file)
```

So, here we've already all the pieces...

- We can train a pipeline with our database of spam
- We can save and restore a pipeline so that we can do the hard work in easy moments and still have fast results when using it
- We can report messages as spam manually and perform actions

The last piece of glue, was extending the `/spam` command to also store the message received and marked as `spam` into the database.

With this approach, the bot is able to work on the current existing database to generate a model, and still allow to grow the database with admin-reported spam messages. Those messages will then be used to train the pipeline periodically either as training or test, helping improving and enhancing the detection

So the actual behavior is that [@redken_bot](https://t.me/redken_bot) does:

- Checks new message if a model for that language exists (only saves it when accuracy is 85% or higher)
  - If it's spam, It will show a keyboard to either mark as spam (confirm) or ignore the message
- Admins can reply with `/spam` to messages, even if there's no model for that language, helping in creating the database of messages
- If a message has been marked as spam, either by replying with `/spam` or by clicking on the button saying that it's spam, the spam process begins:
  - The button is always removed when replying (with the question about spam status)
  - If the message was marked as spam, the original message is removed
    - The user that sent the message, gets added to the database as spammer and then kicked out of the chat
    - The message is stored on the database for future enhancement of the machine language detection.

Additionally, I'm testing a 'ham' training feature, being fed with regular messages to start building a positive set of messages to compare with.

I will continue searching for spam databases in other languages to do an initial set, but in the meantime, it will continue only with English.

Next steps are:

- Promote messages marked as spam on groups into the general list (right now, messages marked as spam will be only stored, but no other work done with them)
  - Once the message is promoted, it would be extracted from the database and put in an external CSV file similar to the SMS collection for the relevant language for future training.
- Use the list of blocked UID with status global, to warn in groups where that user is in, showing the chance to kick the user.
- `spamcheck` set to `auto`, automatically deletes the spam messages and reports the user, together with previous item, it will also auto-kick users

<do... erxxx>

Enjoy and happy filtering!
