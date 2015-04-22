---
title: Git Stashing
author: NC
category: git
public: true
---

## Stashing

- Assume, you are working on part of your project, things are in a messy state and you want to switch branches for a bit to work on something else. The problem is, you don’t want to do a commit of half-done work just so you can get back to this point later.
- Stashing takes the dirty state of your working directory and saves it on a stack of unfinished changes that you can reapply at any time.

```sh
$ git stash (save)
# pushes a new stash onto your stack
Saved working directory and index state \
  "WIP on master: 049d078 added the index file"
HEAD is now at 049d078 added the index file
(To restore them type "git stash apply")

$ git status
# On branch master
nothing to commit, working directory clean

$ git stash --keep-index
# dont stash anything that you have already staged.

$ git stash --include-untracked
$ git stash --u
# include untracked files.

$ git stash list
stash@{0}: WIP on master: 049d078 added the index file
stash@{1}: WIP on master: c264051 Revert "added file_size"
stash@{2}: WIP on master: 21d80a5 added number to log

$ git stash apply stash@{2}
# files staged before aren't staged.
$ git stash apply stash@{2} --index
# files staged before are staged.

$ git stash drop stash@{0}
# remote a stash

$ git stash pop
# apply the stash and then immediately drop it.


$ git stash --patch
# git will prompt you interactively which of the changes you would like to stash
# and which you would like to keep in your working directory.

$ git stash branch testchanges
# creates a new branch
# checks out the commit you were on when you stashed your work,
# reapplies your work there,
# drops the stash if it applies successfully

```

- You can run `git stash apply` even if you are not on the same branch you created the stash or you have modified and uncommited files in your working directory after the stash – Git gives you merge conflicts if anything no longer applies cleanly.



**References**

- [Pro Git - Book](http://git-scm.com/book)
