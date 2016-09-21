---
title: Docker
author: NC
category: devops
public: true
---


### Service Discovery and Global Configuration Stores

- Allows applications to obtain the data needed to connect with to the services they depend on.
- Allows services to register their connection information for the above purpose.
- Provides a globally accessible location to store arbitrary configuration data.
- ex. ZooKeeper, Consul, etcd, crypt, confd

### Networking

- Docker's native networking capabilities:
	1 - expose a container's ports and optionally map to the host system for external routing.
	2 - allow containers to communicate by using Docker "links".
- Some additional networking capabilities available through additional tools:
	- Overlay networking to simplify and unify the address space across multiple hosts.
	- Virtual private networks adapted to provide secure communication between various components.
	- Assigning per-host or per-application subnetting
	- Establishing macvlan interfaces for communication
	- Configuring custom MAC addresses, gateways, etc. for your containers
- ex. flannel, weave, pipework



**References**

- <https://speakerdeck.com/alp/istanbul-azure-meetup-docker-talk>
- <https://ahmetalpbalkan.com/blog/herding-code-podcast/>
- [Deni Bertović - Supercharge your development environment using Docker](https://www.youtube.com/watch?v=Z_o5eaNZhZQ)
- <https://medium.com/aws-activate-startup-blog/a-better-dev-test-experience-docker-and-aws-291da5ab1238>
- <https://www.digitalocean.com/community/tutorial_series/the-docker-ecosystem>
