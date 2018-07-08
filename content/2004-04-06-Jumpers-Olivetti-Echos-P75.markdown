---
layout: post
comments: true
title: Jumpers Olivetti Echos P75
date: 2004-04-06T10:01:00Z
tags: hardware, general
---

Olivetti Echos Family (Tested on my P75, but obtained from the Internet)
(Running now at 166 mhz)

|   Jumper Settings |  Processor Speed|
|  -----------------| -----------------|
|  1100   |           75 MHz|
|  0000    |          90 MHz|
|  0100     |         100 MHz|
|  1110      |        100 MHz|
|  0010       |       120 MHz|
|  1111        |      120 MHz|
|  0110         |     133 MHz|
|  0011          |    150 MHz|
|  1101           |   150 MHz|
|  0001            |  166 MHz|
|  0111             | 166 MHz|

Switchs 1,2:

|  Switch 1 |  Switch 2 |  bus|
|  ----------| ----------| ------|
|  OFF|        OFF |       60|
|  OFF |       ON   |      66.6|
|  ON   |      OFF   |     20|
|  ON    |     ON |        50|

Switch 3,4:

| Switch 3 |  Switch 4 |  Multiplier|
|  ----------| ----------| ------------|
|  OFF  |      OFF|        1.5x|
|  OFF |       ON  |       3x|
|  ON |        OFF  |      2x|
|  ON|         ON    |     2.5x|

You'll find those jumpers under the sound card, remove the ring from the outside part of the notebook, then remove the plastic pieces that keep keyboard in its position, then remove a screw that is retainning an aluminum piece (acting as disipator for the microprocessor) . Then, you'll see the sound card piece in the left side of the notebook, lift it up and you'll see a four switch piece... configure it as showed in the table before and you'll set the new processor speed.

I don't know if this will damage your computer, so I give you no warranty, if you proceed, you're doing it at your own risk, all that I can say is that this worked for me. I've just replaced P75 for a P120 processor, I did this without any "overclocking" intention, just using real processor.

¡Good Luck!

Mine stopped working in August, the screen gets white and only Fn-F11 and Fn-F12 seems to work, hard disk is working properly, CPU too, so it seems a problem with the mainboard. I've found several cases on Internet regarding this problem, and some describe it as an oscillator problem that makes it boot sometimes and other no.

For me, it's always not working, I try from time to time because I keep hope on its awakening...

UPDATE: 1st October 2006, I've tried to boot it up for trying to update an USR2450 AP card I use with LinuxAP , and it booted! it said that there was a problem with the RTC clock, but after configuring bios properly, I have it on... when I'm finished with updating the pcmcia card (newer notebook has no pcmcia slot) I'll try to shutdown and retest...

SECOND UPDATE: After moving the notebook for connecting a parallel cable from my zip drive, computer shutdown, and now, has the video problem again... bad luck :'(

I've the following hardware if someone interested in buying it:

Olivetti Echos P75 system:

- Motherboard
- DSTN Screen
- Spanish Keyboard
- Sound card
- Floppy drive
- Used battery
- Power adapter

THIRD UPDATE: 17th November 2007: At [How to create a digital frame](http://www.dkomputer.com/cadrephoto/index_us.html) says that the problem with the blinking cursor is related with battery being exhausted (as a visitor pointed too). Will try :)
