---
author: iranzo
title: The experience of writing a book
tags:
  - foss
  - RHEL
  - book
  - Packt Publishing
  - system administration
  - RHCSA
  - writing a book
layout: post
date: 2021-09-15 00:00:00 +0100
categories:
  - Book
lang: en
modified: 2022-05-04T13:32:56.669Z
---

I wanted to write about my experience (before I forget about it), and as some colleagues asked about it... here we go...

As published in the blog entry [RHEL8 Administration book]({{<ref "2021-09-11-rhel8-administration.en.md">}}), some colleagues and I wrote a book on RHEL8 administration, which can be bought [here](https://s.iranzo.io/rhel8).

Many years ago I started one about Linux, but every time a new paragraph was added, a lot of new 'TO-DO' items were appended as the information growth... and as it was a 'solo' project, I had other stuff to work on and was parked.

Later last year (2020), Miguel approached asking if I was interested in helping him with his book, he started it, but the schedule was a bit tight, not impossible, but, having to work on the book at night, once kids are sleeping, you might be tired of work, etc... was not the best one, so after some thinking about it, I told him that I was willing to help with the task, which automatically, duplicated the available time for each chapter.

Not all chapters were equal, I must admit, some took me more time to 'start', but I think it was a good experience, I learned a lot, and I think it will help others in the future.

Many times I end up spending time digging on issues, trying to find the right answer, and once found, it seemed pretty obvious that it should be the way since the beginning, thing is... to realize that, you need to spend the time digging, testing, etc... and, even if I try to publish some stuff on the blog about that sort of 'tricks' I tend to think that those are not helpful, so I end up not adding them most of the times.

With the book, while working on the chapters, I had time to revisit stuff, that was obvious in my head, but not for others that are in the process of learning, and to even refresh the status of projects that I wasn't touching for a while.

For example, when I started working in consulting, I was doing a lot of Anaconda for automating installations, with custom scripts to detect the hardware, write to serial ports to show data on systems without monitors, but since I moved to more 'professional' setups, my experience switched more to the post-installation configuration using playbooks in Ansible to do get the things done.

Let's back to talk about the book itself...

After we divided the chapters the work was more bearable and compatible with the time we had available, so the focus was working on the chapters. So, since January, I was enrolled in this effort :-)

As Miguel had an outline of the topics to cover for each chapter, it was easy to use the freedom we had to cover them, the examples, but of course, always having in sight the focus on the tasks that a system administrator would perform at RHCSA level. One of the metrics we had, was the expected page count, but also, it was flexible and some chapters were bigger than expected and some others, smaller, of course, depending on the topic and well.... we finally exceeded in about 100 pages the expected page count.

On the tech side, I'm used to Markdown and I've used it at several roles in my career, and lately, I was doing Asciidoctor. I'm not a big expert in Asciidoctor but it had many features that I felt being useful for the book, however, to my surprise, the tool of choice was a word processor with some custom styling. I understand, that using a regular word processor makes it easier for other writers, and having version control was also useful, but still was a bit strange for me, as I was used to code reviews, easy to perform on text files, and also, doing cross-references between different documents. Even when working with SuSE on the manuals, the choice was LaTeX, which was even harder but allowed rich features on the final rendering.

On the other side, the Packt team provided good guidance for starting:

- Styling guide with some example documents demonstrating each style usage
- Shared drive for uploading the files and work on reviews
- And lot of support for the questions that arise

And what was more invaluable: guidance by several members of the team about the styles to use, tense, writing style, etc

The process was quite fast, once each chapter was submitted, in few days or a week, there were some reviews and later, a technical reviewer did the same, providing a feedback form on the chapter and some other things to fix or improve.

In the end, going chapter after chapter, it went quickly through... my biggest pain points were the chapters where I felt that there was nothing else to add, and writing just for increasing the page count was not something we had in mind, and of course, the Packt team supported us in the decision.

I think that the hardest chapter was the two on exercises... the book has two knowledge-check-in chapters and once the first was done, thinking about a second without repeating many of the stuff in the first one was not easy.

June arrived, all the chapters were delivered and some other reviews were still ongoing on the last chapters, so the book was almost finished and ready for the last steps.

The last stone in the road meant little effective work for us as it was mostly adjusting some of the wording and paperwork, but once we got clearance in September (close to three months to complete), we were able to move into the final stage.

Looking back, it has been a good experience, which somehow was shaking the way I was writing before (as writing Knowledge Base Articles, requires using another styling for the phrasing, etc.), going more direct and engaging more with the reader, but very positive.

Finally, when everything was done, another member of the Packt team did start over with the book, doing quality assurance, checking the content, clarity, etc, like a second Technical reviewer, before handing it over to the marketing team to work on the promotion of the book on social media.

Will I do this once again? of course!
