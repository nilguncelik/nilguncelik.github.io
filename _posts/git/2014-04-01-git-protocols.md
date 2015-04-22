---
title: Git Protocols
author: NC
category: git
public: true
---


## Git Protocols

Git can use four major protocols to transfer data: Local, HTTP, Secure Shell (SSH) and Git.

### Local Protocol

- remote repository is another directory on disk.
- not reachable from locations that dont have access to the disk

### HTTP

#### Smart HTTP

- You can use things like username/password basic authentication rather than having to set up SSH keys.
- It can be set up to both serve anonymously, and can also be pushed over with authentication and encryption. You can now use a single URL for both. If you try to push and the repository requires authentication (which it normally should), the server can prompt for a username and password. The same goes for read access.

#### DUMB HTTP

- It expects the bare Git repository to be served like normal files from the web server.
- It is very simple to setup (all you have to do is put a bare Git repository under your HTTP document root and set up a specific post-update hook, and you’re done). Anyone who can access the web server under which you put the repository can also clone your repository.

#### SSH Protocol

- Advantages:
	- SSH access to servers is already set up in most places – and if it isn’t, it’s easy to do.
	- It is secure - all data transfer is encrypted and authenticated.
- Disadvantages
	- People must have access to your machine over SSH to access it, even in a read-only capacity, which doesn’t make SSH access conducive to open source projects.

##### Generating Your SSH Public Key

- <https://help.github.com/articles/generating-ssh-keys/>

#### The Git Protocol
- This is a special daemon that comes packaged with Git; it listens on a dedicated port (9418) that provides the service with absolutely no authentication.

- Either the Git repository is available for everyone to clone or it isn’t. You can enable push access; but given the lack of authentication, if you turn on push access, anyone on the internet who finds your project’s URL could push to your project.
-  Generally, you’ll pair it with SSH or HTTPS access for the few developers who have push (write) access and have everyone else use git:// for read-only access.
- Hard to setup.
- It requires firewall access to port 9418, which isn’t a standard port that corporate firewalls always allow. Behind big corporate firewalls, this obscure port is commonly blocked.



**References**
- [Pro Git - Book](http://git-scm.com/book)
