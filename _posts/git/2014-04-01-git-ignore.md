---
title: git ignore
author: NC
category: git
public: true
---


### Ignoring Files

- Often, you’ll have a class of files that you don’t want Git to automatically add or even show you as being untracked.
- You can create a file listing patterns to match them named .gitignore. Here is an example .gitignore file:


```sh
$ cat .gitignore
*.[oa]    # ignore any files ending in .o or .a
* ̃				 # ignore all files that end with tilde
# a comment  this is ignored
*.a       # no .a files
!lib.a    # but do track lib.a, even though you’re ignoring .a files above
/TODO     # only ignore the root TODO file, not subdir/TODO
build/    # ignore all files in the build/ directory
doc/*.txt # ignore doc/notes.txt, but not doc/server/arch.txt
doc/**/*.txt  # ignore all .txt files in the doc/ directory
```

- Setting up a .gitignore file before you get going is generally a good idea so you don’t accidentally commit files that you really don’t want in your Git repository.

- [A collection of useful .gitignore templates](https://github.com/github/gitignore)


**References**

- [Pro Git - Book](http://git-scm.com/book)
