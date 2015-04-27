---
title: git cherry pick
author: NC
category: git
public: true
---


- It is like a rebase for a single commit. It takes the patch that was introduced in a commit and tries to reapply it on the branch you’re currently on.
- It creates an entirely new commit based off the original and it does not delete the original commit.
- This is useful if you have a number of commits on a topic branch and you want to integrate only one of them, or if you only have one commit on a topic branch and you’d prefer to cherry-pick it rather than run rebase.

```sh
$ git cherry-pick <commit id from a feature branch>
```

- This pulls the same change introduced in `<commit id from a feature branch>`, but you get a new commit SHA-1 value, because the date applied is different. Now you can remove your feature branch and drop the commits you didn’t want to pull in.



### Conflict handling

```sh

$ git cherry-pick <commit id>
# if there are conflicts you can manually resolve them and execute

$ git status
# will show you which files are in conflict
$ git cherry-pick --continue
# or you can skip conflict or abort cherry-pick:
$ git cherry-pick --abort
```

**References**

- [Pro Git - Book](http://git-scm.com/book)
