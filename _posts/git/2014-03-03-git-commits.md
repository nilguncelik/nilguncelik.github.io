---
title: Git Commits
author: NC
category: git
public: true
---


- Remember that Git doesn’t store data as a series of change sets or differences, but instead as a series of snapshots.
- Let’s assume that you have a directory containing three files, and you stage them all:

```sh
$ git add README test.rb LICENSE
```

- Staging the files checksums each file, stores that version of the file (called **blobs**) in the Git repository, and adds that blobs to the staging area.

```sh
$ git commit -m 'initial commit of my project'
```
- When you create the commit, Git checksums each subdirectory (in this case, just the root project directory) and stores those **tree objects** in the Git repository. Then creates a commit object that has the metadata and a pointer to the root project tree so it can re-create that snapshot when needed.

- Your Git repository now contains 5 objects:
	- **blob objects** for the contents of each of your three files,
	- **one tree object** that lists the contents of the directory and specifies which file names are stored as which blobs, and
	- **one commit object** with the pointer to that root tree, pointers to the commit or commits that directly came before this commit and all the commit metadata (author’s name and email, authoring date commiter, commit date, commit message).

- Git then creates a SHA-1 hash over all these 5 objects:

	```
	sha1( commit message, commiter, commit date, author, author date, tree, parents)
	```

	- This lets Git to have integrity because there is no chance that bits gets lost in transit without Git knowing about it.

![](/img/git_anatomy_of_a_commit.png)



- If you make some changes and commit again, the next commit stores a pointer to the commit that came immediately before it.

![](/img/git_commit_parents.png)


- Lets look at the tree object closer.
	- Assume we have a tree structure like this
	```
	.
	├── .git (contents left out)
	├── assets
	|   ├── logo.png
	|   └── app.css
	└── app.js
	```
	- Here is what Git’s representation of the working directory looks like.

	![](/img/git_commit_tree_object.png)

	- The root tree object maps names to hashes and those hashes can refer to blobs (for files) or other tree objects which in turn are dictionaries themselves that map names to hashes which can refer to… and so on.

### Showing a specific commit:

```sh
git show <commit>
```


### Specifying Commits


```sh
$ git show <unambigious first characters of SHA-1 hash>

$ git show <branch-name>
# shows the last commit object on the branch

$ git reflog
734713b HEAD@{0}: commit: fixed refs handling, added gc auto, updated
d921970 HEAD@{1}: merge phedders/rdocs: Merge made by recursive.
1c002dd HEAD@{2}: commit: added some blame and merge stuff
1c36188 HEAD@{3}: rebase -i (squash): updating HEAD
95df984 HEAD@{4}: commit: This is a combination of two commits.
1c36188 HEAD@{5}: rebase -i (squash): updating HEAD
7e05da5 HEAD@{6}: rebase -i (pick): updating HEAD
$ git show HEAD@{5}
$ git show master@{yesterday}
$ git show master@{2.months.ago}


$ git show HEAD^
# parent of head - the branch you were on when you merged
$ git show HEAD^2
# second parent of head - the commit on the branch that you merged in
$ git show HEAD~3
# the first parent of first parent of first parent
# traverses the first parents the number of times you specify
$ git show HEAD^^^
# the first parent of first parent of first parent
$ git show HEAD~3^2



$ git log master..experiment
# all commits reachable by experiment that aren’t reachable by master.
$ git log experiment..master
# all commits reachable by master that aren’t reachable by experiment.
$ git log origin/master..HEAD
# see what your are about to push to remote
$ git log origin/master..
# git assumes HEAD if one side is missing
$ git log master..experiment
$ git log ^master experiment
$ git log experiment --not master
# all commits reachable by experiment that aren’t reachable by master.
# You can specify more than 3 references to `^` and `--not`

$ git log --left-right master...experiment
# all the commits that are not reachable by either of two references

```

### Viewing Changes Between commits

```sh
git diff commitId1 commitId2
# differences between two commits
git diff <sourceBranch> <targetBranch>
# view differences between commits that these branches point to
```


**References**

- [Pro Git - Book](http://git-scm.com/book)
- [The anatomy of a Git commit](http://blog.thoughtram.io/git/2014/11/18/the-anatomy-of-a-git-commit.html)
