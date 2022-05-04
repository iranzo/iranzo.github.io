---
author: Pablo Iranzo Gómez
title: Upstream/Downstream documentation workflow
tags:
  - GitHub Actions
  - Netlify
  - AsciiDoctor
  - automation
  - dit
  - foss
layout: post
date: 2020-12-01 14:10:34 +0200
categories:
  - tech
  - CMS
lang: en
modified: 2022-05-04T14:03:30.778Z
---

During last year I've worked with the <https://github.com/openshift-kni/baremetal-deploy/> repository after being working in the KNI Community team that was in charge of <KubeVirt.io> and <Metal3.io> where some of the below things were applied.

One of the goals we had was to streamline the upstream <-> downstream process to keep changes done in the right way: get changes upstream and copy over downstream with minimal changes.

We ended up using AsciiDoctor for building the documentation in the same way it's done downstream so it's just a matter of copying over the modules.

- AsciiDoctor can have variables replaced via command line parameters
- Can reuse the modules combined in different order to build different docs based on conditionals, `master` files, etc
- Can output both HTML and PDF format so it's easy to create downloadable guides as well as browse-able ones

In addition, as we use GitHub as a backend, we added some GitHub Actions workflows together with Netlify.

Netlify provides a 'free' service for Open Source projects that allows to 'render' PR's based on the defined scripts, in our case, that means building the documentation website fully for each PR received, so that you can directly see how the changes in a module are rendered in the final book without requiring manual checkout and build of the changes.

We've added GitHub actions for:

- On each commit on the main branch, an action that runs Jekyll and a shell script `build.sh` is executed, this creates:
  - HTML and PDF versions for each release defined in build.sh (we currently build from the same set of modules, the documentation for OpenShift 4.3 up to 4.7
  - JSON is created based on the documents rendered and stored in a file.
  - Jekyll renders an `index.md` that loops over the items in the JSON to show the list of available documents.
  - All above are pushed to another branch that is served via HTTP as a webpage using GitHub Pages at https://openshift-kni.github.io/baremetal-deploy/
- Additionally:
  - New users are welcomed on their first contribution.
  - Old issues/PR's are tagged and later closed if not updated.
  - Issues are labelled according to target regular expressions.
  - Ansible linting is performed on the `Ansible playbooks` we use in the repository.
  - Broken links are checked.

This whole process has automated our workflow, reducing the time spent on checking changes and by having a live preview of new changes and automatically built PDF versions that can be downloaded and accessed offline for onsite customer visits.

{{< gravizo>}}

digraph flow {
"New Commit" -> "Run CI"
"Run CI" -> "GitHub Actions"
"Run CI" -> "Netlify"
"Netlify" -> "Is the PR Correct?"
"Is the PR Correct?" [shape=diamond]
"GitHub Actions" -> "Page Build"
"GitHub Actions" -> "Spell Check"
"GitHub Actions" -> "Greetings"
"GitHub Actions" -> "Label"
"Spell Check" -> "Is the PR Correct?"
"Page Build" -> "Is the PR Correct?"
"Is the PR Correct?" -> "New Commit" [label="Fix commit and resend"];
"Greetings" -> "Ready for Merging"
"Label" -> "Ready for Merging"
"Ready for Merging" -> "Page Build"
"Is the PR Correct?" -> "Final Page Build" [label="Yes"];
"Final Page Build" -> "Site is Live" [label="push to branch"];
"Site is Live" [shape=square];
}

{{< /gravizo>}}

Best practices:

- Reuse as much as possible and keep the process simple: both for contributors and for reviewers, with this, you're fostering collaboration: This is the way.
- Use automation wherever is possible, it might make things more complicated (like failing a PR because of a typo), but the end result will be worth it... if not, you can perform those checks periodically and have extra work to do:
  - automated spelling check
  - website building (with proper tags for SEO, that will help your project to get known)
  - output format creation, etc.
- If Upstream/Downstream has differences, try to get to a common ground: the less differences between booth, means more effective use of the time on creating new things or improving instead of reconciling changes
- Be FAST on answering to issues and PR's, people has invested time into raising them (sometimes a bit of research should have avoided it, but many times that means a problem in usability, lack of clarity on the text, etc and instead of just going away, they did they part to raise it). It feels really bad when someone opens an issue or even contributes and gets no response/feedback from project maintainers. And even worse, when other changes get in the way and PR needs to be re-based once and over again instead of being merged.

Feel free to reach with questions if any!
