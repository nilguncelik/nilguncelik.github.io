---
title: Git Merging Branches
author: NC
category: git
public: true
---

```sh
$ git checkout master
$ git merge <branch-to-be-merged>
```
- Merge changes from <another-branch> to master.
- If `master` branch has not changed since `<another-branch>` was created, git does a **fast-forward**.
	- i.e. the commit pointed to by the branch you merged in is directly upstream of the commit you’re on, Git simply moves the pointer forward.
	- i.e. when you try to merge one commit with a commit that can be reached by following the first commit’s history, Git simplifies things by moving the pointer forward because there is no divergent work to merge together – this is called a **fast-forward**.

	![](/img/git_before_fast_forward_merge.png)
	![](/img/git_after_fast_forward_merge.png)

- If changes were made to both branches, a **recursive merge commit** is executed.
	- i.e. the development history diverges from some older point.
	- Because the commit on the branch you’re on isn’t a direct ancestor of the branch you’re merging in, Git has to do some work.
	- It does a 3 way merge using the two snapshots pointed to by the branch tips and the common ancestor of the two.
	- Instead of just moving the branch pointer forward, Git creates a new snapshot that results from this three-way merge and automatically creates a new commit that points to it.
	- This is referred to as a merge commit, and is special in that it has more than one parent.

	![](/img/git_before_recursive_merge.png)
	![](/img/git_after_recursive_merge.png)

### Merge Conflicts

- If you changed the same part of the same file differently in the two branches you’re merging together, Git won’t be able to merge them cleanly.
- If you want to see which files are unmerged at any point after a merge conflict, you can run `git status`.
- Git adds standard conflict-resolution markers to the files that have conflicts, so you can open them manually and resolve those conflicts.
- After you’ve resolved each of these sections in each conflicted file, run `git add` on each file to mark it as resolved. Staging the file marks it as resolved in Git.
- If you want to use a graphical tool to resolve these issues, you can run git mergetool, which fires up an appropriate visual merge tool and walks you through the conflicts
- You can run `git status` again to verify that all conflicts have been resolved.
- If you’re happy with that, and you verify that everything that had conflicts has been staged, you can type `git commit` to finalize the merge commit.

- If possible, try to make sure your working directory is clean before doing a merge that may have conflicts.
- If you have work in progress, either commit it to a temporary branch or stash it. This makes sure you don't loose any data.
- If you weren’t expecting conflicts and don’t want to quite deal with the situation yet, you can simply back out of the merge with `git merge --abort`. Note that this may loose unstashed, uncommitted changes.
- If you see that you have a lot of whitespace issues in a merge, you can simply abort it and do it again, this time with `-Xignore-all-space` (ignores whitespace completely when comparing lines) or `-Xignore-space-change` (treats sequences of one or more whitespace characters as equivalent).
- If you would prefer Git to simply choose a specific side and ignore the other side instead of letting you manually merge the conflict, you can pass the merge command either a `-Xours` or `-Xtheirs`.

### Undoing merges

- If you have just made a merge by mistake and nobody has this version just run `git reset -- hard HEAD~`.
- Otherwise you can make a new commit which undoes all the changes from an existing one:

```sh
$ git revert -m 1 HEAD
```
- `-m 1`
	- indicates which parent is the "mainline" and should be kept.
	- if you merged topic into master, 1 is master, 2 is topic.

- Note that Git will get confused and see no changes if you try to merge topic again. What’s worse, if you add work to topic and merge again, Git will only bring in the changes since the reverted merge.
- The best way around this is to un-revert the original merge, since now you want to bring in the changes that were reverted out, then create a new merge commit if you have additional work on topic: `git revert ^M` and `git merge topic`.



**References**
- [Pro Git - Book](http://git-scm.com/book)
