---
title: Git Contributing to a project
author: NC
category: git
public: true
---

1. Fork project into your workspace.

2. Create a topic branch from master.

	```sh
	￼$ git clone https://github.com/<your-user>/<project>
	$ cd project
	$ git checkout -b new-topic
	```
	-  It’s easier to have a `master` branch always track `origin/master` and to do your work in topic branches.
		- You can easily discard if they’re rejected.
		- You can rebase your work if the tip of the main repository has moved in the meantime and your commits no longer apply cleanly.
		- You can submit a second topic of work to the project parallelly.

3. Make some commits to improve the project.

	```sh
	$ git diff --word-diff

	$ git commit -a
	```

4. Push this branch to your GitHub project.

	```sh
	$ git push origin new-topic
	```

	- It’s easiest to push the topic branch you’re working on up to your repository, rather than merging into your master branch and pushing that up. The reason is that if the work isn’t accepted or is cherry picked, you don’t have to rewind your master branch. If the maintainers merge, rebase, or cherry-pick your work, you’ll eventually get it back via pulling from their repository.
	- You may want to use `rebase -i` to squash your work down to a single commit, or rearrange the work in the commits to make the patch easier for the maintainer to review.

5. Open a PR on GitHub.
	- Enter title and description.
	- Github also shows list of the commits in our topic branch that are "ahead" of the master branch and a unified diff of all the changes that will be made should this branch get merged by the project owner.

6. Discuss, and optionally continue committing.

7. The project owner merges or closes the PR.
	- If the merge is trivial, he just hits the "Merge" button on the GitHub site.
		- This will do a "non-fast-forward" merge, creating a merge commit even if a fast-forward merge is possible.
		- Many projects don’t really think of PRs as queues of perfect patches that should apply cleanly in order, instead as iterative conversations around a proposed change, culminating in a unified diff that is applied by merging.
		- When code is proposed with a PR and the maintainers suggest a change, the contributor does not rebase his commit and send another PR. Instead they add new commits and push them to the existing branch. This way if you go back and look at this PR in the future, you can easily find all of the context of why decisions were made. Pushing the "Merge" button on Github purposefully creates a merge commit that references the PR so that it’s easy to go back and research the original conversation if necessary.
	- He can also pull the branch down and merge it locally using one of 2 possible ways:
		1. `git pull <url> <branch>`
			- This does a one-time pull and doesn’t save the URL as a remote reference.
		2. add the fork as a remote and fetch and merge.
		 	- You can use this if you are continuously developing with this person.
	- As a 3rd way he can use PR refs.
		- GitHub actually advertises the PR branches for a repository as sort of pseudo-branches on the server. By default you don’t get them when you clone.
		- If we run `git ls-remote` command against the "blink" repository, we will get a list of all the branches and tags and other references in the repository.
		```sh
		$ git ls-remote https://github.com/schacon/blink
		10d539600d86723087810ec636870a504f4fee4d	HEAD
		10d539600d86723087810ec636870a504f4fee4d	refs/heads/master
		6a83107c62950be9453aac297bb0193fd743cd6e	refs/pull/1/head
		afe83c2d1a70674c9505cc1d8b7d380d5e076ed3	refs/pull/1/merge
		3c8d735ee16296c242be7a9742ebfbc2665adec1	refs/pull/2/head
		15c9f4f80973a2758462ab2066b6ad9fe8dcf03d	refs/pull/2/merge
		a5a7751a33b7e86c5e9bb07b26001bb17d775d1a	refs/pull/4/head
		31a45fc257e8433c8d8804e3e848cf61c9d3166c	refs/pull/4/merge
		```
		- Note that the PR branches are prefixed with `refs/pull/`. These are basically branches, but since they’re not under `refs/heads/` you don’t get them normally when you clone or fetch from the server — the process of fetching ignores them normally.
		- There are two references per PR:
			- the one that ends in `/head` points to exactly the same commit as the last commit in the PR branch. So if someone opens a PR in our repository and their branch is named bug-fix and it points to commit `a5a775`, then in our repository we will not have a bug-fix branch (since that’s in their fork), but we will have `pull/<pr#>/head` that points to `a5a775`.
			- the one that ends with `/merge` represents the commit that would result if you push the "merge" button on the site. This can allow you to test the merge before even hitting the merge button.
		- One thing you can do is to fetch the reference directly:
		```sh
		$ git fetch origin refs/pull/958/head
		# Connect to the origin remote, download the ref named refs/pull/958/head,
		# put a pointer to the commit you want under .git/FETCH_HEAD.
		```
		- You can follow that up with `git merge FETCH_HEAD` into a branch you want to test it in, but that merge commit message looks a bit weird. Also, if you’re reviewing a lot of pull requests, this gets tedious.
		- Alternative way is to fetch all of the pull requests, and keep them up to date whenever you connect to the remote.

		```sh
		$ vi .git/config

		[remote "origin"]
		       url = https://github.com/libgit2/libgit2
		       fetch = +refs/heads/*:refs/remotes/origin/*
					 # refspec i.e. the things on the remote that are under refs/heads
					 # should go in my local repository under refs/remotes/origin.
		       fetch = +refs/pull/*/head:refs/remotes/origin/pr/*
					 # All the refs that look like refs/pull/123/head should be stored
					 # locally like refs/remotes/origin/pr/123
		```

		- Now, if you do a `git fetch` all of the remote pull requests are represented locally with refs that act much like tracking branches; they’re read-only, and they update when you do a fetch. This makes it super easy to try the code from a pull request locally.

		```sh
		$ git fetch
		#...
		 * [new ref]  refs/pull/1/head -> origin/pr/1
		 * [new ref]  refs/pull/2/head -> origin/pr/2
		 * [new ref]  refs/pull/4/head -> origin/pr/4
		#...
		$ git checkout pr/2
		```

	- If he decides he doesn’t want to merge it, he closes the PR and the person who opened it will be notified.

#### Determining What Is Introduced in a PR￼￼

- Getting a review of all the commits that are in this branch but that aren’t in your master branch.

```sh
$ git log contrib --not master
# exclude commits in the master branch
$ git log contrib master..contrib
```

- To see a full diff of what would happen if you were to merge this topic branch with another branch

```sh
$ git diff master
```
- if you master has moved forward this is misleading.
- ex. if you’ve added a line in a file on the master branch, a direct comparison of the snapshots will look like the topic branch is going to remove that line.
- If master is a direct ancestor of your topic branch, this isn’t a problem. Otherwise run

```sh
$ git diff master...contrib
```
- shows you only the work your current topic branch has introduced since its common ancestor with master.



#### PR merge conflicts

- You have two main options in order to fix it.

	1. You can rebase your branch on top of whatever the target branch is (normally the master branch of the repository you forked).
		- This is not preferred approach as it more difficult and error prone.
		- If you absolutely wish to rebase the branch to clean it up, you can certainly do so, but it is highly discouraged to force push over the branch that the PR is already opened on (your PR branch). If other people have pulled it down and done more work on it, you run into the issues that rebase introduces when it is used on public branches (your collaborators will have to re-merge their work and things will get messy when you try to pull their work back into yours.).

		```sh
		$ git checkout featureB
		$ git rebase origin/master
		$ git push -f myfork featureB
		```

		- Because you rebased the branch, you have to specify the `-f` to your push command in order to be able to replace the featureB branch on the server with a commit that isn’t a descendant of it.

		![](/img/git_pr_conflicts_rebase_1.png)

		- Instead, push the rebased branch to a new branch on GitHub and open a brand new PR referencing the old one, then close the original.

		```sh
		$ git checkout -b featureBv2 origin/master
		$ git merge --no-commit --squash featureB
		# takes all the work on the featureB and squashes it into
		# one non-merge commit on top of featureBv2
		# (fix conflicts)
		$ git commit
		# this commit has similar changes with featureB,
		# but does not include commits in featureB.
		$ git push myfork featureBv2
		```
		![](/img/git_pr_conflicts_rebase_2.png)

	2. You can merge the target branch into your branch.
		- Add the original repository as a new remote, fetch from it, merge the main branch of that repository into your topic branch, fix any issues and finally push it back up to the same branch you opened the PR on.
		- more preferable because it keeps the history.
		```sh
		# you are on new-topic branch
		$ git remote add upstream https://github.com/<owner>/<project>
		$ git fetch upstream
		$ git merge upstream/master
		# conflict warning for blink.ino file
		$ vim blink.ino
		# conflict resolved
		$ git add blink.ino
		$ git commit
		$ git push origin new-topic
		```

		- If you have a very long-running project, you can easily merge from the target branch over and over again and only have to deal with conflicts that have arisen since the last time that you merged, making the process very manageable.


### Commit best practices

- Before you commit, run `git diff --check`, which identifies possible whitespace errors and lists them for you.
- Try to make each commit a logically separate change set.
	- Try to make your changes digestible – don’t code for a whole weekend on five different issues and then submit them all as one massive commit on Monday.
	- Even if you don’t commit during the weekend, use the staging area on Monday to split your work into at least one commit per issue, with a useful message per commit.
	- If some of the changes modify the same file, try to use `git add -- patch` to partially stage files.
	- This approach makes it easier to review your code and to pull out or revert one of the change sets if you need to later.
	- Use tools for rewriting history and interactively staging files to help craft a clean and understandable history before sending the work to someone else.
	- Create good quality commit messages.
		- your messages should start with a single line that’s no more than about 50 characters and that describes the change set concisely,
		- followed by a blank line,
		- followed by a more detailed explanation which includes your motivation for the change and contrast its implementation with previous behavior
		- Use imperative present tense in these messages. In other words, use commands. Instead of “I added tests for” or “Adding tests for,” use “Add tests for.”.


#### Referencing an entity in Github

- `#<num>`
	- refers to a PR or an issue in the project.

- `username#<num>`
	- refers to a PR or an issue in a fork of the repository you’re in.

- `username/repo#<num>`
	- refers to something in another repository.

- `40 character SHA-1`
	- refers to a commit.





**References**
- [Pro Git - Book](http://git-scm.com/book)
