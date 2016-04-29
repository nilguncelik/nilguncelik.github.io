---
title: Containers
author: NC
category: docker
public: true
---

### Virtual Machines

![](/img/virtual_machine.png)

- They manage security and resource sharing.
- But they are inefficient (each vm allocates resources for the guest os).

## Containers

- A container is OS Level Virtualization.
- OS Level Virtualization is a server virtualization method where the kernel of an operating system allows for multiple isolated user space instances, instead of just one.
- Containers may look and feel like a real server from the point of view of its owners and users.

![](/img/container.png)

- Works as a process.
	- Efficient scheduling.
	- Less overhead.
- Boot very fast compared to virtual machines.
- Crash management and resiliency
	- Easy to kill and restart
	- Limits DDOS attacks. One container can be hit by DDOS, but another mat not be hit. You can easily kill and start another.
- Portable - runs same everywhere.
- Kernel provides isolation and resource management based on LXC (Linux Containers)
	- Provides base OS container templates and a comprehensive set of tools for container lifecycle management.
	- Kernel level namespace isolation and security.
		- Two separate processes can have same id in container but they are different according to OS.
		- Two separate containers can see different drivers named as C.
		- pid, mnt, net, uts, ipc, user,...
	- cgroup
		- Kernel feature for limiting resource usage (cpu, memory, bulkio, devices)
- When you start a new container:
	- It is like starting a new process on the operation system, no other overhead.
	- No disk storage required.
	- No OS booting required.
- When you quit the container, any data written on storage is deleted. If you mount a folder, data on the folder is deleted also unless another process is using it.



**References**

- <https://speakerdeck.com/alp/istanbul-azure-meetup-docker-talk>
- <https://ahmetalpbalkan.com/blog/herding-code-podcast/>
- [Deni Bertović - Supercharge your development environment using Docker](https://www.youtube.com/watch?v=Z_o5eaNZhZQ)
- <https://medium.com/aws-activate-startup-blog/a-better-dev-test-experience-docker-and-aws-291da5ab1238>
- <https://www.digitalocean.com/community/tutorial_series/the-docker-ecosystem>
