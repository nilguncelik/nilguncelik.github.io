---
title: Git Remote Repositories
author: NC
category: git
public: true
---

## Remote Repositories

### Showing remote repositories:

```sh
$ git remote -v
origin git://github.com/<user>/<project>.git
```

- You can have multiple repositories and pull contributions from any of these repositories. But you can push to only one remote which is origin.


### Inspecting a remote

```sh
$ git remote show origin
* remote origin
  URL: git@github.com:defunkt/github.git
  Remote branch merged with ’git pull’ _while on branch issues
    issues
  Remote branch merged with ’git pull’ _while on branch master
    master
  New remote branches (next fetch will store in remotes/origin)
    caching
  Stale tracking branches (use ’git remote prune’)
		libwalker
    walker2
  Tracked remote branches
    acl
    apiv2
    dashboard2
    issues
    master
    postgres
  Local branch pushed with ’git push’
    master:master
```

- It lists
	- the URL for the remote repository
	- the tracking branch information.
		- which branch is automatically pushed when you run git push on certain branches.
		- which remote branches on the server you don’t yet have.
		- which remote branches you have that have been removed from the server.
		- multiple branches that are automatically merged when you run git pull.
			- for ex. if you’re on the master branch and you run `git pull`, it will automatically merge in the master branch on the remote after it fetches all the remote references.
	- all the remote references it has pulled down.


### Adding/Removing remote repositories:

```sh
git remote add <name> <address>
git remote add origin https:/github.com/<name>/<project>.git
# origin will refer to given url.
git remote add pb https:/github.com/paul/<project>.git
git remote rm <name>
```

- If you cloned a repository, the command automatically adds that remote repository under the name origin and creates a local branch under the name master.


### Fetching changes from remote repository

```sh
$ git fetch <remote>
# checkouts <remote>/master branch to local repository.
$ git fetch
# checkouts origin/master branch to local repository.
```

- `git fetch` goes out to that remote project and pulls down all the data from that remote project that you don’t have yet.
- Then you have references to all the branches from that remote, which you can merge in or inspect at any time.
- It’s important to note that this command pulls the data to your local repository — it doesn’t automatically merge it with any of your work or modify what you’re currently working on. You have to merge it manually into your work when you’re ready.




### Updating local repository with changes from remote repository

- If you have a branch set up to track a remote branch, you can use the `git pull` command to automatically fetch and then merge a remote branch into your current branch.

```sh
git pull (origin master)
```
1. Fetches/syncs local repository with the remote one.
	- Actually it creates a new branch called `origin/master`.
	- Same as `git fetch`.
2. Merges origin/master with master.
	- Same as `git merge origin/master`.
	- Pops up a new editor to enter a new commit message.
	- Creates a new commit for this merge.


### Pushing changes to remote repository:


- When you have your project at a point that you want to share, you have to push it upstream.

```sh
git push <remote> <branch>
git push ( origin master )
# push to remote repository (origin) from local branch (master)
```
- `-u` option tells git to remember the parameters, so that next time you run git push, git will know what to do.
- This command works if you have write access to remote and if nobody has pushed since you last pulled the remote code. In that case your write will be rejected. You’ll have to pull down their work first and incorporate it into yours before you’ll be allowed to push.




### Resolving conflicts:

```sh
# Without conflict:
git push
# rejected
git pull
git push

# With conflict:
git pull
# conflict
git status
# manually edit conflicted files.
git commit -a
git push
```

- <http://stackoverflow.com/questions/18050220/eclipse-egit-checkout-conflict-with-files-egit-doesnt-want-to-continue>




**References**

- [Pro Git - Book](http://git-scm.com/book)
