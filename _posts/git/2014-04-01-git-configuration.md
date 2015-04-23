---
title: Git Configuration
author: NC
category: git
public: true
---



## Configuration

- `git config --system`
	- kept in /etc/gitconfig.
- `git config --global`
	- kept in ~/.gitconfig.
	- user specific.
- `git config`
	- kept in .git/config.
	- repository specific.


```sh
$ git config --global user.name <user-name>
$ git config --global user.email <email>

$ git config --global color.ui true
$ git config --global core.editor vim
$ git config --global format.pretty oneline
```



### Showing configuration:

```sh
git config --list
git config user.name
```


### Storing Credentials

`$ git config --global credential.helper store --file <file-name>`

- Your passwords are stored in cleartext in a plain file in your home directory by default.
- On mac they’re encrypted with the same system that stores HTTPS certifi- cates and Safari auto-fills.
- On windows you can use winstore.


### Excludes


- Sytem Excludes

```sh
$ vi .git/info/exclude
```

- Global Excludes

```sh
$ git config --global core.excludesfile ~/.gitignore_global
$ vi ~/.gitignore_global
*~
.DS_Store
logs/
._*
.AppleDouble
Thumbs.db
*.sublime-*
TODO
TEMP_*
.srvr*
*.sw[op]
```

- It is like a global .gitignore file for all your repositories.
- [A collection of useful .gitignore templates](https://github.com/github/gitignore)

- Project excludes

```sh
$ vi .gitignore
```
- This will ignore logs folder for all people using this repository.




### Newline Problems

- Windows uses both a carriage-return character and a linefeed character (CRLF) for newlines in its files, whereas Mac and Linux systems use only the linefeed character (LF).
- Many editors on Windows silently replace existing LF-style line endings with CRLF, or insert both line-ending characters when the user hits the enter key.

- On Windows
	- `$ git config --global core.autocrlf true`
	- this converts LF endings into CRLF when you check out code.
- On Mac and Linux
	- `$ git config --global core.autocrlf input`
	- this converts CRLF to LF on commit but not the other way around.
- This setup should leave you with CRLF endings in Windows checkouts, but LF endings on Mac and Linux systems and in the repository.

- If you and and your team develops on Windows only you can turn off this feature
	- `$ git config --global core.autocrlf false`
	- then CR will be in the repository as well.


### Whitespace problems

- `blank-at-eol`
	- looks for spaces at the end of a line;
- `blank-at-eof`
	- notices blank lines at the end of a file
- `space-before-tab`
	- looks for spaces before tabs at the beginning of a line.
- `indent- with-non-tab`
	- looks for lines that begin with spaces instead of tabs (and is controlled by the tabwidth option)
- `tab-in-indent`
	- watches for tabs in the indentation portion of a line
- `cr-at-eol`
	- tells Git that carriage returns at the end of lines are OK.

```sh
$ git config --global core.whitespace trailing-space,space-before-tab,indent-with-non-tab
```
- Git will detect these issues when you run a `git diff` command and try to color them so you can possibly fix them before you commit.



### Creating aliases:

```sh
$ git config --global alias.st status
$ git st
# alias for git status

$ git config --global alias.unstage 'reset HEAD --'
$ git config --global alias.last 'log -1 HEAD'
$ git config --global alias.detailed-log 'log --pretty=format:"%h %ad %s" --date=short --all'
$ git config --global alias.decorative-log 'log --graph --oneline --decorate --abbrev-commit --all'
```

### Binary Files

```sh
$ vi .gitattributes
*.pbxproj binary
# tells Git to treat all .pbxproj files as binary data:
```

- Now, Git won’t try to convert or fix CRLF issues; nor will it try to compute or print a diff for changes in this file when you run git show or `git diff` on your project.

```sh
# set up word filter
$ git config diff.word.textconv docx2txt
$ vi .gitattributes
*.docx diff=word
```

- This tells Git that any file that matches this pattern (.docx) should use the "word" filter when you try to view a diff that contains changes.

```sh
# set up word filter
$ git config diff.exif.textconv exiftool
$ vi .gitattributes
*.png diff=exif
```





**References**

- [Pro Git - Book](http://git-scm.com/book)
