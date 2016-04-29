---
title: Docker Commands
author: NC
category: devops
public: true
---

# Start Docker Engine as deamon
`sudo docker -d &`

# Image Repo

### login to Hub.
`$ sudo docker login`

### search existing remote images from Index/Hub (https://index.docker.io)
`$ sudo docker search ubuntu`


# Images

### download ubuntu image and put in cache.
`$ sudo docker pull ubuntu`

### show local downloaded or built (from Dockerfile) images.
`$ sudo docker images`


# Running (Creating an instance)

`$ sudo docker run <image-name> <options> <commands>`

- ex. `$ sudo docker run ubuntu echo "Hello"`
- some containers have commands baked in so you dont always have to specify it.

### run - instance will exit after executing the command
`$ sudo docker run -it ubuntu /bin/bash`

### run - instance will open an interactive shell and will not exit
`$ sudo docker run -it centos:centos6  /bin/bash`
- you can disconnect without existing instance by pressing ctl+p ctl+q

### run options
- `--link`: If you link mysql server and nginx server they can recognize ports of each other.
- `-v`: give host folder to docker.
- `-p`: The port that are going to be opened. These are assigned to random ports in the host system.
- `-t`: allocate pseudo tty interaction
- `-i`: keep standard in open even something is not attached
- `-env`: provide env file or prod parameters from outside.
- `-d`: deamon mode

# Instances
### show running instances together with their container ids.
`$ sudo docker ps`
### start/stop/kill running docker instance.
`$ sudo docker start <CID>`
`$ sudo docker stop <CID>`
`$ sudo docker kill <CID>`

# Logs
### show standard output.
`$ sudo docker logs <CID>`


# Networking
### assign host's port 49168 to containers port 8080.
`$ sudo docker run -p 49168:8080 -d <image-name>`
- i.e. you can access to web server running on port 8080 in the container by issuing following command: "curl -i localhost:49168"








**References**

- <https://speakerdeck.com/alp/istanbul-azure-meetup-docker-talk>
- <https://ahmetalpbalkan.com/blog/herding-code-podcast/>
- [Deni Bertović - Supercharge your development environment using Docker](https://www.youtube.com/watch?v=Z_o5eaNZhZQ)
- <https://medium.com/aws-activate-startup-blog/a-better-dev-test-experience-docker-and-aws-291da5ab1238>
- <https://www.digitalocean.com/community/tutorial_series/the-docker-ecosystem>
