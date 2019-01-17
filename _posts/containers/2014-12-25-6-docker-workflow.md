---
title: Docker
author: NC
category: devops
public: true
---


**Docker Workflow**

There are two major ways to work with docker.

1 - Manual Commiting

![](/img/manual_image_creation.png)

- You write your application and make configurations.
- Commit your app and configuration.
- Checkout your instance on another machine and use.
- This way is not recommended.

```sh
$ docker container run -i -t debian /bin/bash
$ apt-get install postgresql-9.3
$ docker ps
$ docker commit <CID> username/postgresql
$ docker login
$ docker push username/postgresql
# on another computer
$ docker pull username/postgresql
```

2- Dockerfile

- Set parent image and then run series of commands.
- Recommended way.
- Dockerfile also serves as a documentation what you did to create that image.
- You still need to push and pull commands manually to get the new image to the Hub.

```sh
$ docker build -t <image-name> <directory>
# includes all the elements in the directory when the source file is built to an image repository.
# will create a reusable image, will not run it.
```
- [Reference for writing Dockerfiles](https://docs.docker.com/reference/builder/).
- Docker encourage immutable deployment units. You should not ssh into container and do upgrades. Instead just change the version number of the base image and then rebuilt your application container and deploy it. If you start to connect with ssh to your container then you break the nature of immutability and you are creating something that is not exactly reproducible.


- Docker workflow:
Build: Docker Toolbox. output: image?
Ship: Docker Hub Registry, your local registry
Run: Any vm capable of running docker containers.


**References**

- <https://speakerdeck.com/alp/istanbul-azure-meetup-docker-talk>
- <https://ahmetalpbalkan.com/blog/herding-code-podcast/>
- [Deni Bertović - Supercharge your development environment using Docker](https://www.youtube.com/watch?v=Z_o5eaNZhZQ)
- <https://medium.com/aws-activate-startup-blog/a-better-dev-test-experience-docker-and-aws-291da5ab1238>
- <https://www.digitalocean.com/community/tutorial_series/the-docker-ecosystem>
