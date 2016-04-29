---
title: Docker
author: NC
category: devops
public: true
---


### Scheduling, Cluster Management, and Orchestration

- Schedulers are responsible for starting containers on the available hosts. It has functions that automate host selection process with the administrator having the option to specify certain constraints.

**Docker Machine, Swarm and Compose**

- Docker Machine, allows developers to quickly spin up Docker on a variety of cloud platforms. You can start remote machines on the cloud providers with Docker installed using command line. Then, you can run docker commands in the remote machine.
- Docker Swarm provides developers with a native clustering and scheduling solution.
- [Demo of the Machine + Swarm + Compose integration](https://www.youtube.com/watch?v=M4PFY6RZQHQ)


**CoreOS**

- is a minimal host OS (Linux) for Docker.

- Instead of installing packages via yum or apt, CoreOS uses Linux containers to manage your services at a higher level of abstraction. A single service's code and all dependencies are packaged within a container that can be run on one or many CoreOS machines.


**Mesosphere**

- An orchestration tool from Twitter

**Kubernetes**

- An orchestration tool from Google
- for clustering Docker containers across nodes.
- inspired by Googles internal systems like Borg/Omega.




**References**

- <https://speakerdeck.com/alp/istanbul-azure-meetup-docker-talk>
- <https://ahmetalpbalkan.com/blog/herding-code-podcast/>
- [Deni Bertović - Supercharge your development environment using Docker](https://www.youtube.com/watch?v=Z_o5eaNZhZQ)
- <https://medium.com/aws-activate-startup-blog/a-better-dev-test-experience-docker-and-aws-291da5ab1238>
- <https://www.digitalocean.com/community/tutorial_series/the-docker-ecosystem>
