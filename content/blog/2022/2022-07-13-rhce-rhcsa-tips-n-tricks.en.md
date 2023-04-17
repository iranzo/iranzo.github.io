---
title: RHCE and RHCSA tips and tricks
date: 2022-07-13T21:00:35.086Z
tags:
  - RHCE
  - RHCSA
  - RHEL
  - FOSS
  - Linux
categories:
  - FOSS
cover:
  image: https://admins.guru/rhel8-cover.png
modified: 2023-04-17T21:42:40.512Z
---

I did the RHCE exam some time ago, and still there are some tricks and
advices I tell the people to bear in mind some of the things I used and that were also provided in the [Red Hat Enterprise 8 Administration](https://s.admins.guru/buyonamazon) book:

- Don't remember every step, it's not effective, for example as I don't recall syntax for BIND, I do remember package that has some files with examples and I use that one to check what I need to do
- Install `mlocate` and run `updatedb` as soon as you start, then you can use `locate <file>` to find out files in your system
- Use your preferred editor... it's common to use `vi` or `vim` as it's pretty standard, but if you're used to another, make yourself comfortable in the system.
- As one instructor like to say: "Anyone with unlimited amount of time will be able to pass the exam".
- RHCE is a performance-based exam, that means that you need to cover all the required goals within the exam duration, and in the end, the goals is to accomplish, not to do in the `smarter` way.
  - For example, if you're told to configure `resolv.conf` you can either use `nmcli` to modify the settings or you can pipe the results to it via `echo nameserver 1.1.1.1 > /etc/resolv.conf`, in the end, both will have the same effect, and of course, using `nmcli` will be smarter when you're keeping multiple systems and using automation... but for the exam, the goal is to focus on the fastest path to master at it.

You can find more tricks at [Red Hat Enterprise 8 Administration](https://s.admins.guru/buyonamazon)
{{<enjoy>}}
