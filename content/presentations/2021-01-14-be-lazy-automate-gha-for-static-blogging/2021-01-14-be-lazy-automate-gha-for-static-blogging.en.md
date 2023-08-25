---
author: Pablo Iranzo Gómez
title: "Be lazy, automate: GitHub actions for static blogging"
tags:
  - pelican
  - foss
  - github
  - github actions
  - reveal
layout: list
date: 2021-01-14 22:24:00 +0100
categories:
  - presentations
  - CMS
outputs:
  - Reveal
reveal_hugo.theme: solarized
lastmod: 2023-08-25T09:48:47.768Z
---

## Be lazy, automate: GitHub Actions for static blogging

/me: Pablo Iranzo Gómez ( <https://iranzo.io> )

---

## What is a blog?

A place to share knowledge, interests, tips, etc.

Usually features:

- images
- comments from visitors,
- related articles,
- etc.

---

## What are the costs for a blog?

Web costs money:

- Hosting
- Domain
- Maintenance
- etc.

---

## What is static blogging?

Generate a static webpage

- Think of it as rendering templates into HTML
- Has no requirements on the web server, any simple Webserver is enough:
  - Look ma!, no database!
  - Look ma!, no users!
  - Look ma!, no security issues!

---

## What does it mean to us?

- We write an article
- Command for generating html from templates is used
- New files uploaded to Webserver

---

## [Some Philosophy](https://www.youtube.com/watch?v=cJMwBwFj5nQ)

> Empty your mind, be shapeless, formless, like water.
> Now you put water in a cup, it becomes the cup, you put water into a bottle, it becomes the bottle
> You put water in a teacup, it becomes the teapot
> Now water can flow or it can crash.
> Be water my friend

Note:
Automation: Be lazy, have someone else doing it for you.

---

## Git Hub / Gitlab

- Lot of source code is hosted at GitHub, Gitlab or other services, but it's a code repository.
- BUT: We want a website!!

---

## Pages come to play

- Git Hub provides a service called [GitHub Pages](https://pages.github.com/)
- Git lab provides [Gitlab pages](https://about.gitlab.com/product/pages/)

Both provide a 'static' Webserver to be used for your projects **for free** 😜

G(H/L) serve from a branch in your repo (usually `yourusername.github.io` repo)

You can buy a domain and point it to your repo.

---

## Static doesn't mean end of fun

There are many 'static' content generators that provide rich features:

- styles
- links
- image resizing
- even 'search'

---

## Even more fun with external services

- comments
- mailing lists
- etc.

---

## Some static generators

Importance of language is for developing 'plugins', not content.

- Jekyll (Ruby)
- Pelican (Python)
- Hugo(Go)

They 'render' markdown into html

---

## There's even more fun

- Github provides Jekyll support out of the box.
- Github, Gitlab, etc allow to plug in third-party CI
- Github has Actions

Think about endless possibilities!!!

---

## What are Github actions?

- Github is a repository for code

  - Allows third-party integration: Travis, Jenkins, bots, etc

- Github added GitHub Actions
  - For all repositories
  - For free
  - Easy to define new actions
  - 'cloning' with just a yaml in the repo

---

## What can we find?

- CI
- Formatting
- Linting
- Publishing
- Anything can be combined!!
- A full Marketplace (https://github.com/marketplace?type=actions)

---

## Some food for thought

- Repositories have branches
- Repositories can have automation
- External automation like Travis CI can do things for you

Note:
We've all the pieces to push a new markdown file and have it triggering a website update and publish

---

## Is a static webpage ugly?

- There are lot of templates <http://www.pelicanthemes.com>
- Each theme has different feature set
- Choose wisely! (Small screens, html5, etc)
  - If not, changing themes is quite easy: update, and 'render' using a new one.

---

## Travis-ci.org

Automation for projects:

- Free for Open Source projects
- Configured via `.travis.yml`
- Some other settings via Web interface (environment variables, etc)

---

## Why Actions?

- Configured within yaml files in the repo
- GitHub pre-creates a token that can be used to push new files, branches, etc
- Without too much hassle, we've all the pieces!

---

## Wrap up

Ok, automation is ready, our project validates commits, PR's, website generation...

What else?

---

## Test it yourself

Try <https://github.com/iranzo/blog-o-matic/>

Fork to your repo and get:

- minimal setup steps
- Automated setup of Pelican + Elegant theme via Git Hub action that builds on each commit.
- Ready to be submitted to search engines via `sitemap`, and web claiming

---

## Questions?

Pablo.Iranzo@gmail.com

- <https://iranzo.io>
