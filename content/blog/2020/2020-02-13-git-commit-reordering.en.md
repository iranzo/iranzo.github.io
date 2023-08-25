---
author: Pablo Iranzo Gómez
title: Git commit reordering
tags:
  - git
  - FOSS
  - Linux
layout: post
date: 2020-02-13 20:30:24 +0100
categories:
  - tech
lang: en
lastmod: 2023-08-25T09:48:46.773Z
---

While I was working for a presentation for kid's school at [Magnetic field, Aurora, Lunar Phases and Rockets]("campo-magnetico-auroras-fases-lunares-cohetes.md"), I added 4 big videos to the presentation (as I was going to use them offline while presenting).

I know what git is not the place for big binary files, and even Github proposed to use the LFS backend for that, but as it was just temporary, I went ahead.

After that commit, I also wrote two more articles, the one on [Lego Speed Champions]({{<relref "2020-02-08-lego-speed-champions-2020.en.md">}}) and the one on [Galleria.io and PhotoSwipe]({{<relref "2020-02-12-galleriaio-and-photoswipe.en.md">}}), so it became a problem to have big files in between, when my plan was to remove them in the end.

Git allows you to create branches at any point and play around with the commits, cherry-picking them into your branch, etc so for continue working I did create a new branch:

```sh
git checkout -b branchwithoutpresentation
```

{{<tip>}}
Until this point, we've not performed any 'damage' to the repository (and we still could revert back), make sure you're testing on a repository suitable before doing this on valuable data.
{{</tip>}}
Then, I wanted to remove the 'problematic commit' by running:

```sh
git rebase -i HEAD~20
```

In that way, git offers you an editor with the latest 20 commits in the branch so that you can elect to 'drop' the ones that are problematic, in this case the one from the presentation.

To do so, go to the line describing the commit of the presentation and change `pick` to `d` and when the editor saves the changes and exits, the git history will be rewritten and the files dropped.

We've done that only in a new branch, so the original branch with the code (`source` in my case), still contains the presentation.

To rewrite the history and have the presentation in the end, we need to:

```sh
git checkout source
git rebase -f branchwithoutpresentation
```

Above command will rewrite 'source' commits to be 'on top' of the `branchwithoutpresentation` branch (the one without the presentation), leaving us with all the commits ordered, and in the last one, the presentation itself.

This allowed me to continue editing the last commit (`git commit --amend --no-edit`) adding or removing files always on the same commit, so once the big files where uploaded to
YouTube, I could just drop them from the repository leaving it clean again.

However, this means that the commits where altered in order, being the latest one, a commit 'dated' earlier, of course, the end results didn't changed, but wanted my git history to look 'linear', so I did the following procedure to 'insert' the commit back where it belonged:

```sh
git log  # to get list of commits (write down the commit number for the presentation)
         # also, write down the commit 'after' the presentation should be inserted
git checkout -b sortedbranch commitafterthepresentationshouldbeinserted
git cherry-pick commitnumberofthepresentation
git checkout source # to get back to the regular branch
git rebase -f sortedbranch
```

At this point, the remaining commits of the `source` branch were added on top of `sortedbranch`, leaving us in a ordered git log and in this case, without the big files in the repository.

{{<danger>}}
At this point, a simple `git push` will not allow you to update your upstream repository as the history is not linear (from their point of view), so a `git push --force` is needed to overwrite remote repository with local changes. This is destructive if others have made changes on the repository, so be really sure about what you do before doing it.
{{</danger>}}
Happy git playing!
