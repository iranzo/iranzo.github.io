---
layout: post
title: Filtering email with imapfilter
date: 2015-08-28 15:27:47 +0200
comments: true
tags: linux, email, imap, imapfilter, Fedora
description:
---

Since some time ago, email filter management was not scaling for me as I was using server-side filtering, I had to deal with the web-based interface which was missing some elements like drag&drop reordering of rules, cloning, etc.

As I was already using offlineimap to sync from the remote mailserver to my system into a maildir folder, I had almost all the elements I needed.

After searching for several options [imapfilter](https://github.com/lefcha/imapfilter) seemed to be a perfect fit, so I started with a small set of rules and start integration with my email process.

On my first attempts, I setup a pre-sync hook on offlineimap by using as well as the postsync hook I already had:

~~~
#!ini
presynchook  = time imapfilter
postsynchook = ~/.mutt/postsync-offlineimap.sh
~~~


Initial attempts were not good at all, applying filters on the remote imapserver was very time consuming and my actual 1 minute delay after finishing one check was becoming a real 10-15 minute interval between checks because of the imapfiltering and this was not scaling as I was putting new rules.

After some tries, and as I already had all the email synced offline, moved filtering to be locally instead of server-side, but as imapfilter requires an imap server, I tricked `dovecot` into using the local folder to be offered via imap:

~~~
#!ini
protocols = imap
mail_location = maildir:~/.maildir/FOLDER/:INBOX=~/.maildir/FOLDER/.INBOX/
auth_debug_passwords=yes
~~~

This also required to change my foldernames to use "." in front of them, so I needed to change `mutt` configuration too for this:

~~~
#!ini
set mask=".*"
~~~

and my mailfoders  script:

~~~
#!ini
set mbox_type=Maildir
set folder="~/.maildir/FOLDER"
set spoolfile="~/.maildir/FOLDER/.INBOX"

#mailboxes `echo -n "+ "; find ~/.cache/notmuch/mutt/results ~/.maildir/FOLDER -type d -not -name 'cur' -not -name 'new' -not -name 'tmp' -not -name '.notmuch' -not -name 'xapian' -not -name 'FOLDER' -printf "+'%f' "`

mailboxes `find ~/.maildir/FOLDER -type d -name cur -printf '%h '|tr " " "\n"|grep -v "^/home/iranzo/.maildir/FOLDER$"|sort|xargs echo`
#Store reply on current folder
folder-hook . 'set record="^"'

~~~

After this, I could start using imapfilter and start working on my set of rules... but first problem appeared, apparently I started having some duplicated email as I was cancelling and rerunning the script while debugging so a new tool was also introduced to 'dedup' my imap folder named [IMAPdedup](https://github.com/quentinsf/IMAPdedup) with a small script:

~~~
#!/bin/bash
(
for folder in $(python ~/.bin/imapdedup.py -s localhost  -u iranzo    -w '$PASSWORD'  -m -c -v  -l)
do
    python ~/.bin/imapdedup.py -s localhost  -u iranzo    -w '$PASSWORD'  -m -c  "$folder"

done
) 2>&1|grep "will be marked as deleted"
~~~

This script was taking care of listing all email foders on 'localhost' with my username and password (can be scripted or use external tools to gather it) and dedup email after each sync (in my `postsync-offlinemap.sh` as well as lbdq script for fetchning new addresses, notmuch and running imapfilter after syncing (to cath the limited filtering I do sever-side)

I still do some  server-side filtering (4 rules), to get on a "Pending sort" folder all email which is either:

- New  support cases remain at INBOX
- All emails from case updates, bugzilla, etc to `_pending`
- All emails containing 'list' or 'bounces' in from to `_pending`
- All emails not containing me directly on CC or To, to `_pending`

This more or less ensures a clean INBOX with most important things still there, and easier rule handling for email sorting.

So, after some tests, this is at the moment a simplified version of my filtering file:

~~~
#!lua
---------------
--  Options  --
---------------

options.timeout = 30
options.subscribe = true
options.create = false

function offlineimap (key)
	local status
	local value
	status, value = pipe_from('grep -A2 ACCOUNT ~/.offlineimaprc | grep -v ^#|grep '.. key ..'|cut -d= -f2')C
        value = string.gsub(value, ' ', '')
        value = string.gsub(value, '\n', '')
        return value
end

----------------
--  Accounts  --
----------------

-- Connects to "imap1.mail.server", as user "user1" with "secret1" as
-- password.
EXAMPLE = IMAP {
    server = 'localhost',
    username = 'iranzo',
    password = '$PASSWORD',
    port = 143
}
-- My email
myuser = 'ranzo'

function mine(messages)
    email=messages:contain_cc(myuser)+messages:contain_to(myuser)+messages:contain_from(myuser)
    return email
end

function filter(messages,email,destination)
	messages:contain_from(email):move_messages(destination)
	messages:contain_to(email):move_messages(destination)
	messages:contain_cc(email):move_messages(destination)
	messages:contain_field('sender', email):move_messages(destination)
end

function deleteold(messages,days)
	todelete=messages:is_older(days)-mine(messages)
	todelete:move_messages(EXAMPLE['Trash'])
end


-- Define the msgs we're going to work on

-- Move sent messages to INBOX to later sorting
sent = EXAMPLE.Sent:select_all()
sent:move_messages(EXAMPLE['INBOX'])

inbox = EXAMPLE['INBOX']:select_all()
pending = EXAMPLE['INBOX/_pending']:select_all()
todos = pending + inbox

-- Mark as read messages sent from my user
todos:contain_from(myuser):is_recent():mark_seen()

-- Delete google calendar forwards
todos:contain_to('piranzo@gapps.example.com'):delete_messages()

-- Move all spam messages to Junk folder
spam = todos:contain_field('X-Spam-Score','*****')
spam:move_messages(EXAMPLE['Junk'])

-- Move Jive notifications
filter(todos,'jive-notify@example.com',EXAMPLE['INBOX/EXAMPLE/Customers/_jive'])

-- Filter EXAMPLEN
filter(todos,'dev-null@rhn.example.com',EXAMPLE['Trash'])

-- Filter PNT
filter(todos:contain_subject('[PNT] '),'noreply@example.com',EXAMPLE['Trash'])

-- Filter CPG (Customer Private Group)
filter(todos:contain_subject('Red Hat - Group '),'noreply@example.com',EXAMPLE['INBOX/EXAMPLE/Customers/Other/CPG'])

-- Remove month start reminders
todos:contain_subject('mailing list memberships reminder'):delete_messages()

-- Delete messages about New accounts created (RHN)
usercreated=todos:contain_subject('New Red Hat user account created')*todos:contain_from('noreply@example.com')
usercreated:delete_messages()

-- Search messages from CPG's
cpg = EXAMPLE['INBOX/EXAMPLE/Customers/Other/CPG']:select_all()
cpg:contain_subject('Cust1'):move_messages(EXAMPLE['INBOX/EXAMPLE/Customers/Cust1/CPG'])
cpg:contain_subject('Cust2'):move_messages(EXAMPLE['INBOX/EXAMPLE/Customers/Cust2/CPG'])
cpg:contain_subject('Cust3'):move_messages(EXAMPLE['INBOX/EXAMPLE/Customers/Cust3/CPG'])
cpg:contain_subject('Cust4'):move_messages(EXAMPLE['INBOX/EXAMPLE/Customers/Cust4/CPG'])

-- Move bugzilla messages
filter(todos:contain_subject('] New:'),'bugzilla@example.com',EXAMPLE['INBOX/EXAMPLE/Customers/_bugzilla/new'])
filter(todos,'bugzilla@example.com',EXAMPLE['INBOX/EXAMPLE/Customers/_bugzilla'])

-- Move all support messages to Other for later processing
filter(todos:contain_subject('(NEW) ('),'support@example.com',EXAMPLE['INBOX/EXAMPLE/Customers/_new'])
filter(todos:contain_subject('Case '),'support@example.com',EXAMPLE['INBOX/EXAMPLE/Customers/Other/cases'])

EXAMPLE['INBOX/EXAMPLE/Customers/_new']:is_seen():move_messages(EXAMPLE['INBOX/EXAMPLE/Customers/Other/cases'])

support = EXAMPLE['INBOX/EXAMPLE/Customers/Other/cases']:select_all()
-- Restart the search only for messages in Other to also process if we have new rules

support:contain_subject('is about to breach its SLA'):delete_messages()
support:contain_subject('has breached its SLA'):delete_messages()
support:contain_subject(' has had no activity in '):delete_messages()

-- Here the process is customer after customer and mark as read messages from non-prio customers
support:contain_body('Cust1'):move_messages(EXAMPLE['INBOX/EXAMPLE/Customers/Cust1/cases'])
support:contain_body('Cust2'):move_messages(EXAMPLE['INBOX/EXAMPLE/Customers/Cust2/cases'])
support:contain_body('Cust3'):move_messages(EXAMPLE['INBOX/EXAMPLE/Customers/Cust3/cases'])
support:contain_body('Cust4'):move_messages(EXAMPLE['INBOX/EXAMPLE/Customers/Cust4/cases'])

-- For customer swith common matching names, use header field
support:contain_field('X-SFDC-X-Account-Number', 'XXXX'):move_messages(EXAMPLE['INBOX/EXAMPLE/Customers/Cust5/cases'])
support:contain_body('Customer         : COMMONNAME'):move_messages(EXAMPLE['INBOX/EXAMPLE/Customers/Cust6/cases'])

-- Non prio customers (mark updates as read)
cust7 = support:contain_body('WATCHINGCUST') + support:contain_body('Cust7')
cust7:mark_seen()
cust7:move_messages(EXAMPLE['INBOX/EXAMPLE/Customers/Cust7/cases'])

-- Filter other messages by domain
filter(todos,'todos.es', EXAMPLE['INBOX/EXAMPLE/Customers/Cust8'])

-- Process all remaining messages in INBOX + all read messages in pending-sort for mailing lists and move to lists folder
filter(todos,'list', EXAMPLE['INBOX/Lists'])
filter(todos,'bounces',EXAMPLE['INBOX/Lists'])

-- Add EXAMPLE lists, inbox and _pending and Fedora default bin for reprocessing in case a new list has been added
lists = todos + EXAMPLE['INBOX/Lists']:select_all() + EXAMPLE['INBOX/Lists/Fedora']:select_all()

-- Mailing lists

-- EXAMPLE
filter(lists,'outages-list',EXAMPLE['INBOX/Lists/EXAMPLE/general/outage'])
filter(lists,'announce-list',EXAMPLE['INBOX/Lists/EXAMPLE/general/announce'])

-- Fedora
filter(lists,'kickstart-list',EXAMPLE['INBOX/Lists/Fedora/kickstart'])
filter(lists,'ambassadors@lists.fedoraproject.org',EXAMPLE['INBOX/Lists/Fedora/Ambassador'])
filter(lists,'infrastructure@lists.fedoraproject.org',EXAMPLE['INBOX/Lists/Fedora/infra'])
filter(lists,'announce@lists.fedoraproject.org',EXAMPLE['INBOX/Lists/Fedora/announce'])
filter(lists,'lists.fedoraproject.org',EXAMPLE['INBOX/Lists/Fedora'])

-- OSP
filter(lists,'openstack@lists.openstack.org',EXAMPLE['INBOX/Lists/OpenStack'])
filter(lists,'openstack-es@lists.openstack.org',EXAMPLE['INBOX/Lists/OpenStack/es'])

-- Filter my messages not filtered back to INBOX
mios=pending:contain_from(myuser)
mios:move_messages(EXAMPLE['INBOX'])

-- move messages we're in BCC to INBOX for manual sorting
hidden = pending - mine(pending)
hidden:move_messages(EXAMPLE['INBOX'])

-- Start processing of messages older than:
maxage=60

-- Delete old messages from mailing lists
deleteold(EXAMPLE['INBOX/Lists/EXAMPLE/general/media'],maxage)
deleteold(EXAMPLE['INBOX/Lists/EXAMPLE/general/outage'],maxage)

-- delete old cases
maxage=180

-- for each in $(cat .imapfilter/config.lua|grep -i cases|tr " ,()" "\n"|grep cases|sort|uniq|grep -v ":" );do echo "deleteold($each,maxage)";done
deleteold(EXAMPLE['INBOX/EXAMPLE/Customers/Cust1/cases'],maxage)
deleteold(EXAMPLE['INBOX/EXAMPLE/Customers/Cust2/cases'],maxage)
deleteold(EXAMPLE['INBOX/EXAMPLE/Customers/Cust3/cases'],maxage)
deleteold(EXAMPLE['INBOX/EXAMPLE/Customers/Other/cases'],maxage)

deleteold(EXAMPLE['INBOX/EXAMPLE/Customers/_bugzilla'],maxage)

-- Empty trash every 7 days
maxage=7
deleteold(EXAMPLE['Trash'],maxage)

~~~

As this is applied filtering twice, `offlineimap` might be uploading part of your changes already, making it faster to next syncs, and suffle some of your emails while it runs.

The point of adding the already filtered set to be filtered again (CPG, cases, etc) is that if a new customer is consiredered to be filter on a folder of its own, the messages will be picked up and moved accordingly automatically ;-)

Hope it helps, and happy filtering!
