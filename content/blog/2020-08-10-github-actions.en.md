---
author: Pablo Iranzo Gómez
title: GitHub Actions for publishing
tags:
  - github
  - publishing
  - github actions
  - blog-o-matic
layout: post
date: "2020-08-10 07:44:24 +0200"
category: tech
lang: en
modified: "2022-01-17T12:01:40.455Z"
---

When I started with [blog-o-matic]({{<ref "2019-01-09-blog-o-matic.en.md">}}) I had to involve external 'Travis-CI', generating a token on GitHub, setting environment variables on Travis, etc

GitHub started enabling [`actions`](https://github.com/features/actions) which allows to automate workflows in a similar way than Travis or other external providers allowed, but with one extra feature: configuration is defined inside `.github/` folder of your repository, which makes incredibly easy to copy the setup for one tool to another (except of optional required tokens that are configured per repo).

One of the 'available' tokens without extra configuration is a token that can be used to push or perform actions on the repo itself without asking user to create the 'Personal Access Token'.

This can be used for things like:

- Welcoming new contributors
- Setting labels on issues/PR's
- Check on project dependencies (`npm`, `pip`, `node`, etc)
- Expire issues/pull requests that are not touched in a period of time
- Allow to push to the repo itself
- etc

Using the push to the repo, allows easily to get whatever is pushed to branch, operate over it and then push results... which results ideal for getting data from one branch and push to Git Hub Pages branch for publishing.

I've been also testing with a Git Hub Action creation to run a custom build command (to get asciidoctor content built to html and PDF), which is now at <https://github.com/iranzo/gh-pages-jekyll-action>.

This enables to chain more complex workflows, like having one repository with content and setup the build process with an action that finally pushes the generated results.

As I wanted to use asciidoc, I adapted a `build.sh` script that gets executed if existing on the repository and some configurable parameters (like website folder, etc) (check details on latest version at <https://github.com/marketplace/actions/github-jekyll-build-action>).

Each time a new push is made to the repository, the GitHub action is executed and output generated.

As a side benefit, as actions work with 'releases', when a new release is done because and improvement is published as a release for the Git Hub Action, `dependabot` will create a PR to update each dependant repository to latest GitHub Action release.

I'm working on getting something similar done with Pelican and then, move the `blog-o-matic` to use that approach to reduce the adoption curve.

Enjoy!
