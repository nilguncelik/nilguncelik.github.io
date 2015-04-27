---
title: git gc
author: NC
category: git
public: true
---

- `reflog` comes to rescue when you screwed up and you want to get back to the way things were before, but you didn’t write down the commit hash.

![](/img/git_reflog.png)

```sh
$ git reflog
734713b HEAD@{0}: commit: fixed refs handling, added gc auto, updated
d921970 HEAD@{1}: merge phedders/rdocs: Merge made by recursive.
1c002dd HEAD@{2}: commit: added some blame and merge stuff
1c36188 HEAD@{3}: rebase -i (squash): updating HEAD
95df984 HEAD@{4}: commit: # This is a combination of two commits.
1c36188 HEAD@{5}: rebase -i (squash): updating HEAD
7e05da5 HEAD@{6}: rebase -i (pick): updating HEAD
```



**References**

- [Pro Git - Book](http://git-scm.com/book)
- <https://speakerdeck.com/singingwolfboy/advanced-git>
