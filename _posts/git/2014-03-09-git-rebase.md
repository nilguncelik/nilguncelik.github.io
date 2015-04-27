---
title: git rebase
author: NC
category: git
public: true
---

- Rebasing is an alternative to merging to integrate changes from one branch to another.

![](/img/git_rebase_1.png)
![](/img/git_rebase_2.png)

- Instead of performing a three-way merge between the two latest branch snapshots (C3 and C4) and the most recent common ancestor of the two (C2), creating a new snapshot and a commit, rebasing takes the patch of the change that was introduced in C4 and reapplies it on top of C3.
- With the rebase command, you can take all the changes that were committed on one branch and replay them on another one.

```sh
$ git checkout experiment
$ git rebase master
First, rewinding head to replay your work on top of it...
Applying: added staged command
```

1. Go to the common ancestor of the two branches (master and experiment),
2. Get the diff introduced by each commit of the branch you’re on (experiment) and save those diffs to temporary files.
3. Reset the current branch to the same commit as the branch you are rebasing onto (master). (run all master commits)
4. Run all commits in the temporary area, one at a time.
5. Nothing is merged during the process.


![](/img/git_rebase_3.png)

- At this point, you can go back to the master branch and do a fast-forward merge.

```sh
$ git checkout master
$ git merge experiment
# this will be fast-forward.
# will not show any merge in history.
```

![](/img/git_rebase_4.png)

- Now, the snapshot pointed to by C4' is exactly the same as the one that was pointed to by C5 in the merge example  – it’s only the history that is different.
	- Rebasing makes a cleaner history. If you examine the log of a rebased branch, it looks like a linear history: it appears that all the work happened in series, even when it originally happened in parallel.

![](/img/git_rebase_5.png)

- Often, you’ll do this to make sure your commits apply cleanly on a remote branch – perhaps in a project to which you’re trying to contribute but that you don’t maintain. In this case, you’d do your work in a branch and then rebase your work onto `origin/master` when you were ready to submit your patches to the main project. That way, the maintainer doesn’t have to do any integration work – just a fast-forward or a clean apply.

### Merge vs Rebase

![](/img/git_history_merge_vs_rebase.png)

- Merge
	- It takes the endpoints and merges them together.
	- It is simple to use and understand.
	- The commits on the source branch remain separate from other branch commits, provided you don’t perform a fast-forward merge. (this separation can be useful in the case of feature branches, where you might want to take a feature and merge it into another branch later)
	- Existing commits on the source branch are unchanged and remain valid; it doesn’t matter if they’ve been shared with others.
	- If the need to merge arises simply because multiple people are working on the same branch in parallel, the merges don’t serve any useful historic purpose and create clutter.

- Rebase
	- It replays changes from one line of work onto another in the order they were introduced.
	- It simplifies your history.
	- It is the most intuitive and clutter-free way to combine commits from multiple developers in a shared branch.
	- Slightly more complex, especially under conflict conditions. (each commit is rebased in order, and a conflict will interrupt the process of rebasing multiple commits.)
	- Rewriting of history has ramifications if you’ve previously pushed those commits elsewhere. (you may push commits you may want to rebase later (as a backup) but only if it’s to a remote branch that only you use. If anyone else checks out that branch and you later rebase it, it’s going to get very confusing.)

- Golden rule of rebasing:
	- Never rebase a branch that you have pushed, or that you have pulled from another person.

	- If you push commits somewhere and others pull them down and base work on them, and then you rewrite those commits with git rebase and push them up again, your collaborators will have to re-merge their work and things will get messy when you try to pull their work back into yours.

	![](/img/git_rebase_remote_1.png)
	![](/img/git_rebase_remote_2.png)

	-  The person who pushed the merged work decides to go back and rebase their work instead; they do a `git push --force` to overwrite the history on the server. You then fetch from that server, bringing down the new commits.

	![](/img/git_rebase_remote_3.png)
	![](/img/git_rebase_remote_4.png)

	- If you run a `git log`, you’ll see two commits that have the same author, date, and message, which will be confusing. Furthermore, if you push this history back up to the server, you’ll reintroduce all those rebased commits to the central server, which can further confuse people. It’s pretty safe to assume that the other developer doesn’t want C4 and C6 to be in the history; that’s why she rebased in the first place.

	![](/img/git_rebase_6.png)


- In general, to bring a feature branch up to date with its base branch, prefer rebasing your feature branch onto the latest base branch if you haven’t pushed this branch anywhere yet, or you know for sure that other people will not have checked out your feature branch. Otherwise, merge the latest base changes into your feature branch.


### Conflict handling

```sh
$ git checkout <branch-name>
$ git rebase master
# if there are conflicts you can manually resolve them and execute

$ git status
# will show you which files are in conflict
$ git rebase --continue
# or you can skip conflict or abort rebase:
$ git rebase --skip # not recommended
$ git rebase --abort

$ git checkout master
$ git merge <branch-name>
```


### Interactive rebase

- `git rebase -i HEAD~3`
	- Will interactively ask you to make changes starting from the oldest commit.
	- Every commit included in the range HEAD~3..HEAD will be rewritten, whether you change the message or not.
	- Don’t include any commit you’ve already pushed to a central server.

```sh
pick f7f3f6d changed my name a bit
pick 310154e updated README formatting and added blame
pick a5f4a0d added cat-file

# Commands:
# p, pick = use commit
# r, reword = use commit, but edit the commit message
# e, edit = use commit, but stop for amending
# s, squash = use commit, but meld into previous commit
# f, fixup = like "squash", but discard this commit's log message
# x, exec = run command (the rest of the line) using shell
#
# These lines can be re-ordered; they are executed from top to bottom.
#
# If you remove a line here THAT COMMIT WILL BE LOST.
#
# However, if you remove everything, the rebase will be aborted.
#
# Note that empty commits are commented out
```

- It allows you to
	- change commit messages (change pick to edit)
	- change the order of commits  (change order of commit lines)
	- remove commits  (remove commit line)
	- squash commits  ( change pick to squash )
	- split commits   ( change pick to edit )
		- when the control drops to command line, first reset to HEAD^, stage files for your first commit, commit, stage files for your second commit, commit, run `git rebase --continue`.





**References**
- [Pro Git - Book](http://git-scm.com/book)
- <https://www.atlassian.com/git/tutorials/merging-vs-rebasing>
- [Git Branching Model](http://www.slideshare.net/lemiorhan/git-branching-model)
- <https://speakerdeck.com/singingwolfboy/advanced-git>
