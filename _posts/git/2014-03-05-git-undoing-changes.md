---
title: Git Undoing Changes
author: NC
category: git
public: true
---


#### Changing your last commit

- If you commit too early, forget to add some files, or you mess up your commit message, you can run commit with the `--amend` option:

```sh
$ git commit -m "initial commit"
$ git add forgotten_file
$ git commit --amend
```

- Changes your last commit message.
- Takes your current staging area and makes it the snapshot for new commit.
- You end up with a single commit — the second command replaces the results of the first.
- Don't amend your commit if you have already pushed it to remote because it changes the SHA-1 of the commit.


#### Unstaging a Staged File

- `git status` command reminds you how to undo changes. For example, let’s say you’ve changed two files and want to commit them as two separate changes, but you accidentally type `git add *` and stage them both. How can you unstage one of the two?

```sh
$ git add .
$ git status
On branch master
Changes to be committed:


(use "git reset HEAD <file>..." to unstage)
    modified:   README.txt
    modified:   benchmarks.rb
```

- Let’s use that advice to unstage the `benchmarks.rb` file:

```sh
$ git reset HEAD benchmarks.rb
benchmarks.rb: locally modified
$ git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

      modified:   README.txt

Changed but not updated:

	(use "git add <file>..." to update what will be committed)
	(use "git checkout -- <file>..." to discard changes in working directory)
    modified:   benchmarks.rb
```

- As you can see now the benchmarks.rb file is modified but once again unstaged.

#### Unmodifying a Modified File

- In the last example output, the unstaged area looks like this:

```
# Changed but not updated:
#
(use "git add <file>..." to update what will be committed)
(use "git checkout -- <file>..." to discard changes in working directory)
    modified:   benchmarks.rb
```
- Let’s do what it says:

```sh
$ git checkout -- benchmarks.rb
# changes already added to index and new files will not be removed.

$ git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

      modified:   README.txt

```

- You can also use `git checkout -p` to partially select which changes to be reverted.

- You can see that the changes have been reverted. You should also realize that this is a dangerous command: any changes you made to that file are gone — Don’t ever use this command unless you absolutely know that you don’t want the file. If you just need to get it out of the way, you can use stashing and branching; these are generally better ways to go.
- Anything that is committed in Git can almost always be recovered. Even commits that were on branches that were deleted or commits that were overwritten with an `--amend` commit can be recovered. However, anything you lose that was never committed is likely never to be seen again.



## Reset Command

- Git as a system manages and manipulates three trees in its normal operation: HEAD, Index, Working Directory
- By "tree" we really mean "collection of files", not specifically the data structure. (There are a few cases where the index doesn’t exactly act like a tree.)


**The HEAD**

- It is a pointer to the current branch reference, which is in turn a pointer to the last commit made on that branch.
- Think of HEAD as the snapshot of your last commit (actual directory listing and SHA-1 checksums for each file).

**The Index**

- It is your proposed next commit i.e. staging area.
- Git populates this index with a list of all the file contents that were last checked out into your working directory and what they looked like when they were originally checked out. You then replace some of those files with new versions of them, and `git commit` converts that into the tree for a new commit.

**The Working Directory**

- The other two trees store their content in an efficient but inconvenient manner, inside the .git folder.
- The Working Directory unpacks them into actual files, which makes it much easier for you to edit them.

- Git’s main purpose is to record snapshots of your project in successively better states, by manipulating these three trees.
- `git add`: takes content in the Working Directory and copies it to the Index.
- `git commit`: takes the contents of the Index and saves it as a permanent snapshot, creates a commit object which points to that snapshot, and updates master to point to that commit.
- `git checkout`: changes HEAD to point to the new branch ref, populates your Index with the snapshot of that commit, then copies the contents of the Index into your Working Directory.
- `git reset`: moves the branch that HEAD is pointing to.
	- If you’re currently on the master branch, running `git reset --soft HEAD^` will make master and HEAD point to HEAD^.
		- This essentially undoes the last `git commit` command. It moves the branch back to where it was, without changing the Index or Working Directory.
		- You could now update the Index and run git commit again to accomplish what `git commit --amend` would have done.
		- The previous HEAD will get cleaned up by git's garbage collector eventually or by running `git gc` manually.
	- If you’re currently on the master branch, running `git reset (--mixed) HEAD^` will make master and HEAD point to HEAD^. And then update the Index with the contents of HEAD^.
		- This is the default mode.
		- It still undoes your last commit, but also unstages everything. You rolled back to before you ran all your `git add` and `git commit` commands.
	- If you’re currently on the master branch, running `git reset --hard HEAD^` will make master and HEAD point to HEAD^. And then update the Index and Working Directory with the contents of whatever snapshot HEAD now points to.
		- `--hard` option is the only way to make the reset command dangerous, and one of the very few cases where Git will actually destroy data.
	- If you’re currently on the master branch, running `git reset (--mixed HEAD) <path>` will update the Index with the contents of snapshot HEAD points to.
		- It essentially copies files in <path> to Index.
		- This has the practical effect of unstaging the file.
		- This is why the output of the git status command suggests that you run this to unstage a file.
		- You can also use `--patch` option to unstage content on a hunk-by-hunk basis.


### Squashing

```sh
# Squashing your latest 2 commits
$ git reset --soft HEAD~2
# move the HEAD branch back to the first commit you want to keep
$ git commit
# this creates a new commit which includes the combination of the 2 commits
# those 2 commits no longer have pointers to them
```

### Checkout vs Reset

#### Without Paths

- `git reset -- hard [branch]`
	- updates all three trees for you to look like [branch].
	- replaces everything across the board without checking.
	- moves the branch pointer that HEAD points to.
- `git checkout [branch]`
	- updates all three trees for you to look like [branch].
	- working-directory safe, makes sure it’s not blowing away files that have changes to them.
	- it tries to do a trivial merge in the Working Directory, so all of the files you haven’t changed in will be updated.
	- moves the HEAD itself to point to another branch.

	![](/img/git_checkout_vs_reset.png)

#### With Paths

- `git reset --mixed <path>`
	- does not move HEAD.
	- updates the index with the files at that commit (HEAD if not given).
- `git checkout <path>`
	- does not move HEAD.
	- updates the index with the files at that commit (HEAD if not given).
	- overwrites the file in the working directory.
	- not working directory safe.


![](/img/git_checkout_vs_reset_2.png)



- Dropping commits:

```sh
git reset --soft HEAD^
# undo last commit and put changes into staging.
git commit --hard HEAD^
# undo last commit, remove all changes.
git commit --hard HEAD^^
# undo last two commits, remove all changes.
```

- Dropping all your local changes and commits:

```sh
git fetch origin
# fetch the latest history from the server.
git reset --hard origin/master
# point your local master branch at it.
```

![](/img/git_undoing.png)


**References**

- [Pro Git - Book](http://git-scm.com/book)
