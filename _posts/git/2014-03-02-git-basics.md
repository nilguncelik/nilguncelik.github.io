---
title: Git Basics
author: NC
category: git
public: true
---


### Git States

**Committed/Unmodified**

- Data is safely stored in your database.


**Modified**

- You have changed the file but have not committed it to your database yet.

**Staged**

- You have marked a modified file in its current version to go into your next commit snapshot.

**Untracked**

- A newly created file.

**Ignored**

- File is ignored by Git.


### Git Directories

**Git Directory**

- It is where Git stores the metadata and object database for your project. This is what is copied when you clone a repository from another computer.
- Git tracks a pointer called HEAD which points to the last commit you have made in the current branch in this directory.

**Working Directory**

- It is a single checkout of one version of the project. These files are pulled out of the compressed database in the Git directory and placed on disk for you to use or modify.
- Each file in your working directory can be in one of 2 states: tracked or untracked.
	- Tracked files are files that were in the last snapshot.
		-  They can be unmodified, modified, or staged.
	- Untracked files are any files in your working directory that were not in your last snapshot and are not in your staging area.

**Staging Area/Index**

- It is a simple file, generally contained in your Git directory, that stores information about what will go into your next commit.
- You use this area to restrict your commit only a subset of the changed files in your working directory.


### Git Workflow

1. You modify files in your working directory.
	- eg. create a file or update a file.
2. You stage the files, adding snapshots of them to your staging area.
3. You do a commit, which takes the files as they are in the staging area and stores that snapshot permanently to your Git directory.


- If a particular version of a file is in the git directory, it’s considered committed. If it’s modified but has been added to the staging area, it is staged. And if it was changed since it was checked out but has not been staged, it is modified.

- Working Directory(unstaged) -> (add) -> Index (staged) -> (commit) -> HEAD (committed).



### Initializing a repository in a existing directory

```sh
cd <my-project>
git init
```

- Initializes an empty git repository by creating .git folder
- At this point, nothing in your project is tracked yet.


### Cloning an existing repository

```sh
git clone <username@host:/path/to/repository> <folder-name>
```

- This command
	1. Creates a directory named `<folder-name>` ( or `<project-name>` if you dont specify a folder name).
	2. Initializes a .git directory inside it.
	3. Pulls down entire repository to this directory.
	4. Adds a remote repository called `origin` which points to `<address>`.
	5. Checks out a working copy of the latest version of main branch - most likely `master`.
	6. Sets the `HEAD` pointer.
- Note that the command is clone and not checkout. This is an important distinction — Git receives a copy of nearly all data that the server has. Every version of every file for the history of the project is pulled down.
- At this point, all of your files are tracked and unmodified because you just checked them out and haven’t edited anything.



### Recording Changes to the Repository

#### Checking the Status of Your Files

- `git status` command is used to determine which files are in which state ( untracked, modified, staged, etc).

```sh
$ git status
On branch master
nothing to commit (working directory clean)
```
- This means you have a clean working directory i.e. there are no tracked and modified files. Also there isn't any untracked files.

- Let’s say you add a new file to your project, a simple README file.

```sh
$ vim README
$ git status
On branch master
Untracked files:
  (use "git add <file>..." to include in what will be committed)

	README

nothing added to commit but untracked files present (use "git add" to track)
```

- Untracked basically means that Git sees a file you didn’t have in the previous snapshot (commit).
- Git won’t start including it in your commit snapshots until you explicitly tell it to do so. It does this so you don’t accidentally begin including generated binary files or other files that you did not mean to include.

#### Tracking new files

```sh
$ git add README
$ git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

new file:   README
```

- You can tell that README file is staged because it’s under the "Changes to be committed" heading.
- When you start tracking a new file it is automatically staged, its status does not change to modified.

### Staging Modified Files

- If you change a previously tracked file called `benchmarks.rb` and then run your status command again, you get something that looks like this:

```sh
$ git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

new file:   README

Changed but not updated:
  (use "git add <file>..." to update what will be committed)

modified:   benchmarks.rb
```

- You can tell `benchmarks.rb` file is a tracked file that has been modified in the working directory but not yet staged because it is under a section named "Changed but not updated".
- To stage it, you run the `git add` command:

```sh
$ git add benchmarks.rb
$ git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

new file:   README
modified:   benchmarks.rb
```

- Both files are staged and will go into your next commit. At this point, suppose you remember one little change that you want to make in benchmarks.rb before you commit it. You open it again and make that change, and you’re ready to commit. Let’s run `git status` one more time:

```sh
$ vim benchmarks.rb
$ git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

new file:   README
modified:   benchmarks.rb

Changed but not updated:
  (use "git add <file>..." to update what will be committed)

modified:   benchmarks.rb
```

- Notice that now benchmarks.rb is listed as both staged and unstaged.
- Git stages a file exactly as it is when you run the `git add` command. If you commit now, the version of `benchmarks.rb` as it was when you last ran the `git add` command is how it will go into the commit, not the version of the file as it looks in your working directory when you run `git commit`. If you modify a file after you run `git add`, you have to run `git add` again to stage the latest version of the file:

```sh
$ git add benchmarks.rb
$ git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

new file:   README
modified:   benchmarks.rb
```

### Note on `git add`

- `git add` is a multipurpose command, you use it to
	- begin tracking new files,
	- stage files,
	- mark merge-conflicted files as resolved.

```sh
git add <list of files>
git add "*.txt"
# stage all txt files in whole project.
git add --all
# stage all new or modified files.
git add *
# stage all new or modified files.
```
- It may be helpful to think of it more as "add this content to the next commit" rather than "add this file to the project".

### Short status

```sh
$ git status -s
 M README              # modified in the working directory but not yet staged.
MM Rakefile            # modified, staged and then modified again, so there are changes to it that are both staged and unstaged.
A  lib/git.rb          # new file that has been added to the staging area.
M  lib/simplegit.rb    # modified and staged.
?? LICENSE.txt         # new file that isn’t tracked.
```


### Interactive staging

- Helps you to include only certain combinations and parts of files in your commits.
- This way, you can make sure your commits are logically separate changesets and can be easily reviewed by the developers working with you.

```sh
$ git add -i
      staged     unstaged path
1:     +0/-1     nothing TODO
2: unchanged     +1/-1 index.html
3:     +1/-1     +4/-0 lib/simplegit.rb

*** Commands ***
  1: status     2: update      3: revert     4: add untracked
  5: patch      6: diff        7: quit       8: help
What now>
```

- It lists the changes you’ve staged (TODO), unstaged (index.html) and partially staged (lib/simplegit.rb).
- Using commands, you can
	- stage files (2)
	- unstage files (3)
	- stage parts of files (5)
	- add untracked files (4)
	- see diffs of what has been staged (6)

- You can also use `git add --p(atch)` to stage parts of files.


### Removing Files

- To remove a file from Git, you have to remove it from your tracked files (more accurately, remove it from your staging area) and then commit.
- The `git rm` command does that and also removes the file from your working directory so you don’t see it as an untracked file next time around.
- If you simply remove the file from your working directory, it shows up under the "Changed but not updated" (that is, unstaged) area of your git status output:

```sh
$ rm grit.gemspec
$ git status
On branch master

Changed but not updated:
  (use "git add/rm <file>..." to update what will be committed)

      deleted:    grit.gemspec

```

- Then, if you run git rm, it stages the file’s removal:

```sh
$ git rm grit.gemspec
rm ’grit.gemspec’
$ git status
On branch master

Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

      deleted:    grit.gemspec

```

- If you modified the file and added it to the index already, you must force the removal with the `-f` option. This is a safety feature to prevent accidental removal of data that hasn’t yet been recorded in a snapshot and that can’t be recovered from Git.

### Removing files while keeping them untracked (keeping them in the hard drive)

- This is particularly useful if you forgot to add something to your .gitignore file and accidentally added it.

```sh
$ git rm --cached readme.txt
```



### Viewing Your Staged and Unstaged Changes

- `git diff` shows you exactly what has changed (exact lines added and removed — i.e. the patch), not just which files were changed.

```sh
$ git diff (HEAD)
# What have you changed but not yet staged?
# i.e. unstaged differences between working copy and last commit.

$ git diff --staged
$ git diff --cached
# What have you staged that you are about to commit?

$ git diff HEAD^
# unstaged differences between working copy and parent of latest commit.

$ git diff HEAD~5
# unstaged differences between working copy and 5 commits ago.
```


![](/img/git_diff_command.png)


- It’s important to note that `git diff` by itself doesn’t show all changes made since your last commit — only changes that are still unstaged. This can be confusing, because if you’ve staged all of your changes, `git diff` will give you no output.



### Committing Your Changes

- When you have everything you want to commit in your staging area, you can commit your changes.
- Remember that anything that is still unstaged — any files you have created or modified that you haven’t run git add on since you edited them — won’t go into this commit. They will stay as modified files on your disk.

```
$ git commit
# doing so opens an editor:
Please enter the commit message for your changes. Lines starting
with ’#’ will be ignored, and an empty message aborts the commit.
On branch master
Changes to be committed:
       new file:   README
       modified:   CONTRIBUTING.md

 ̃
 ̃
 ̃
".git/COMMIT_EDITMSG" 10L, 283C
```

- Default commit message contains the latest output of the `git status` command commented out and one empty line on top.
- If you pass the `-v` option to `git commit`, git puts the diff of your change in the editor so you can see exactly what you did.
- When you exit the editor, Git creates your commit with that commit message (with the comments and diff stripped out).

- Alternatively, you can use `-m` flag:

```sh
$ git commit -m "Story 182: Fix benchmarks for speed"
[master]: created 463dc4f: "Fix benchmarks for speed"
 2 files changed, 3 insertions(+), 0 deletions(-)
 create mode 100644 README
```

- After successful completion, commit gives you some output about itself:
	- which branch you committed to (master),
	- what SHA–1 checksum the commit has (463dc4f),
	- how many files were changed,
	- statistics about lines added and removed in the commit.

- Every time you perform a commit, you’re recording a snapshot of your project that you can revert to or compare to later.


### Skipping the Staging Area

- Providing the `-a` option to the `git commit` command makes Git automatically stage every file that is already tracked before doing the commit, letting you skip the `git add` part.




**References**

- [Pro Git - Book](http://git-scm.com/book)
- <https://www.udacity.com/course/ud775>
