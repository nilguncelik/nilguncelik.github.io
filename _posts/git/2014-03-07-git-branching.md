---
title: Git Branching
author: NC
category: git
public: true
---

- Branching means you diverge from the main line of development and continue to do work without messing with that main line.
- The way Git branches is incredibly lightweight, making branching operations nearly instantaneous, and switching back and forth between branches generally just as fast unlike other version control systems.

![](/img/git_commit_parents.png)

- A **branch** in Git is simply a lightweight movable pointer to a commit. It is in actuality a simple file that contains the 40 character SHA-1 checksum of the commit it points to. Creating a new branch is simple as writing 41 bytes to a file (40 characters and a newline).
- The default branch name in Git is master. As you start making commits, you’re given a master branch that points to the last commit you made. Every time you commit, it moves forward automatically.

![](/img/git_master_branch.png)


### Creating a new branch:

```sh
git branch <branch-name>
git branch testing
```

- This creates a new pointer at the same commit you’re currently on.

![](/img/git_new_branch.png)


- How does Git know what branch you’re currently on? It keeps a special pointer called HEAD. It is a pointer to the local branch you’re currently on. - The `git branch` command only creates a new branch – it does not switch to that branch.


### Listing current branches

```sh
$ git branch
* master  # the branch that HEAD points to.
  testing
```
![](/img/git_head_points_to_master.png)

### Switching to a branch

- This moves HEAD to point to the given branch.
- It most likely changes the files in your working directory.

```sh
$ git checkout <branch-name>
# HEAD now points to <branch-name>.
$ git checkout testing
$ git checkout -b <branch-name>
# create and switch to branch.
```
![](/img/git_head_points_to_branch.png)


- Let's do another commit:
```sh
$ vim test.rb
$ git commit -a -m 'made a change'
```

![](/img/git_head_commit_while_on_a_branch.png)

- Now your testing branch has moved forward, but your master branch still points to the commit you were on when you ran git checkout to switch branches.


- Let’s switch back to the master branch.
	- Note that if your working directory or staging area has uncommitted changes that conflict with the branch you’re checking out, Git won’t let you switch branches. It’s best to have a clean working state when you switch branches. There are ways to get around this (namely, stashing and commit amending).

```sh
$ git checkout master
```

![](/img/git_checkout_to_master.png)

- That command did two things.
	- It moved the HEAD pointer back to point to the master branch, and
	- it reverted the files in your working directory back to the snapshot that master points to.
- This also means the changes you make from this point forward will diverge from an older version of the project.
- It essentially rewinds the work you’ve done in your testing branch so you can go in a different direction.

- Let’s make a few changes and commit again:

```sh
$ vim test.rb
$ git commit -a -m 'made other changes'
```

![](/img/git_seperate_branches.png)


- You can also see this easily with the git log command.

```sh
$ git log --oneline --decorate --graph --all
* c2b9e (HEAD, master) made other changes
| * 87ab2 (testing) made a change
|/
* f30ab add feature #32 - ability to add new formats to the
* 34ac2 fixed bug #1328 - stack overflow under certain conditions
* 98ca9 initial commit of my project
```

### Deleting a branch

```
git branch -d <branch-name>
```

### Other `git branch` options

- `--merged`
	- Shows which branches are already merged into the branch you’re on.
	- Branches on this list without the * in front of them are generally fine to delete; you’ve already incorporated their work into another branch, so you’re not going to lose anything.
- `--no-merged`
	- Shows branches that contain work you haven't merged in.
	- You can't delete these branches with `-d` option, you have to force deletion using `-D`.



## Remote Branches

- Remote branches are references (pointers) to the state of branches in your remote repositories.
- Remote branches act as bookmarks to remind you where the branches on your remote repositories were the last time you connected to them.
- They take the form (remote)/(branch).
- For instance, if you wanted to see what the master branch on your origin remote looked like as of the last time you communicated with it, you would check the origin/master branch.
- If you were working on an issue with a partner and they pushed up an iss53 branch, you might have your own local iss53 branch; but the branch on the server would point to the commit at origin/iss53.
- Git’s clone command automatically names the remote url origin for you, pulls down all its data, creates a pointer to where its master branch is, and names it origin/ master locally. Git also gives you your own local master branch starting at the same place as origin’s master branch, so you have something to work from.

![](/img/git_clone_from_remote_branch.png)

- If you do some work on your local master branch, and, in the meantime, someone else pushes to git.ourcompany.com and updates its master branch, then your histories move forward differently. Also, as long as you stay out of contact with your origin server, your origin/master pointer doesn’t move.

- To synchronize your work, you run a git `fetch origin` command. This command looks up which server "origin" is (in this case, it’s git.ourcompany.com), fetches any data from it that you don’t yet have, and updates your local database, moving your origin/master pointer to its new, more up-to-date position.

![](/img/git_fetch.png)



### Showing remote branches

```sh
$ git branch -r
$ git remote show <remote>
# shows local branches and which remote branches they merge with
# shows local branches commit statuses
```


### Pushing a branch to a remote repository:

```sh
$ git push <remote> <branch>
```

### Fetching from remote repository

```sh
$ git fetch <remote>
```

- When you do a fetch that brings down new remote branches, you don’t automatically have local, editable copies of them. i.e. you don’t have a new <branch-name> branch – you only have an `<remote>/<branch-name>` pointer that you can’t modify.

- To merge this work into your current working branch, you can run `git merge <remote>/<branch-name>`.
- If you want your own `<branch-name>` branch that you can work on, you can base it off your remote branch to create a **tracking branch** or **upstream branch**:

```sh
$ git checkout -b <branch-name> <remote>/<branch-name>
$ git checkout --track <remote>/<branch-name>
```
- This gives you a local branch that you can work on that starts where `<remote>/<branch-name>` is.
- Tracking branches are local branches that have a direct relationship to a remote branch.
	- If you’re on a tracking branch and type `git pull`, Git automatically knows which server to fetch from and branch to merge into.
- When you clone a repository, it generally automatically creates a master branch that tracks origin/master. However, you can set up other tracking branches if you wish – ones that track branches on other remotes, or don’t track the master branch.

- If you already have a local branch and want to set it to a remote branch you just pulled down, or want to change the upstream branch you’re tracking, you can use the `-u` or `--set-upstream-to` option to git branch to explicitly set it at any time.

```sh
$ git branch -u <remote>/<branch-name>
```

```sh
$ git fetch -- all;
# first fetch latest info from remote
$ git branch -vv
```
- Show what tracking branches are set up. It lists out your local branches with information including what each branch is tracking and if your local branch is ahead, behind or both.


### Pulling from remote repository

- `git pull` is a `git fetch` immediately followed by a `git merge`.
- If you have a tracking branch set up, `git pull` will look up what server and branch your current branch is tracking, fetch from that server and then try to merge in that remote branch.
- Generally it’s better to simply use the fetch and merge commands explicitly as the magic of `git pull` can often be confusing.


### Deleting a remote branch:

```sh
git push <remote> --delete <branch>
```

- This removes the pointer and the data from the server.

```sh
git push <remote> :<branch name>
# deletes remote branch but does not remove local one.
git remote prune origin
# when remote repository is deleted by someone else, you have dangling reference to remote branch.
# this command removes that reference and the repository becomes a local one.
```




**References**
- [Pro Git - Book](http://git-scm.com/book)
- [Understanding branches in Git](http://blog.thoughtram.io/git/rebase-book/2015/02/10/understanding-branches-in-git.html)
