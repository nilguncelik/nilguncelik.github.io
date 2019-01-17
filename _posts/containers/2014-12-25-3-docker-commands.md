---
title: Docker Commands
author: NC
category: devops
public: true
---

`docker login` -- login to Hub.
`docker search ubuntu` -- search existing remote images from Index/Hub (https://index.docker.io)
`docker pull ubuntu` -- download ubuntu image and put in cache.
`docker images` -- show local downloaded or built (from Dockerfile) images.
`docker rmi <imageId>`  -- delete an image

`docker container run <image-name> <options> <commands>`  -- Running (Creating an instance)
`docker container run --publish 80:80 --detach --name webserver nginx`
`docker container run --publish 3306:3306 --detach --name mysql --env MYSQL_RANDOM_ROOT_PASSWORD=yes mysql` -- `env` provide env file or prod parameters from outside
`docker container run --rm -it ubuntu bash` -- `rm` Automatically remove the container when it exits

`docker container run ubuntu echo "Hello"`  -- passing commands
- some containers have commands baked in so you dont always have to specify it.

`docker container run -it ubuntu bash`  - starts a container using a command instead of default command in DockerFile.
- `-t`: simulates as a real terminal, like what SSH does
- `-i`: keep session open to receive terminal input
- instance will stop when you exit bash
`docker container start -ai ubuntu`  -- starts a stopped container with bash
`docker container exec -it ubuntu bash` -- run additional process in a running container
- instance will NOT stop when you exit bash

`docker container ls -a`
`docker ps -a` --show instances
`docker container logs <CID|NAME>` -- show standard output
`docker container top <CID|NAME>` -- running top command
`docker container inspect <CID|NAME>` 
`docker container stats <CID|NAME>` 

`docker container start <CID|NAME>`
`docker container stop <CID|NAME>` -- changes remain when you stop and start a container.
`docker container rm <CID|NAME>`  -- one can not remove a running container, you should stop it first or use option `-f` to force.
`docker container rm $(docker ps -aq)`  -- delete all stopped containers
`docker container rm -f $(docker ps -aq)`  -- delete all running and stopped containers
`docker container kill <CID|NAME>`

`docker container port <CID|NAME>` -- show what ports are open for the container on your network
`docker container inspect --format '{{ .NetworkSettings.IPAddress }}' <CID|NAME>` -- get the ip address of the container
- When we start a container, we are connecting to a particular private virtual docker network "bridge/docker0"
- Each virtual network routes through NAT firewall on host IP => this allows your container to get out to the internet or to the rest of your network and then get back.
- Best practice is to create a new virtual network for each app.
    - Containers in the app, do not have to expose their ports to the rest of your physical network (via `-p`) to talk to other containers.
    - You can attach containers to more than one virtual network (or none)

`docker network ls` -- show networks
`docker network inspect <NAME>`
`docker network create --driver bridge <NAME>` -- create a network

`docker container run --publish 80:80 --detach --name webserver --network my_app_net nginx` -- add container to a network while starting
`docker network connect <NETWORK> <CONTAINER>` -- attach a network to container. Dynamically creates a NIC in a container on an existing virtual network
`docker network disconnect <NETWORK> <CONTAINER>` -- detach a network from container

- Static IP's and using IP's for talking to containers is an antipattern.
- Instead create a new network for your apps and use container names as domain names.
- Default network "bridge/docker0" does not support DNS so you should use `--link` option with `docker run`.

`docker image ls`
`docker image history nginx:latest` -- show layers of changes made in image.

- Images are made up of file system changes and metadata.
- Each layer is uniquely identified and only stored once on a host.
- A container is just a single read/write layer on top of image.
Docker works in a copy-on-write (COW) fashion:
- Base layer is read only.
- When you make a change to a file, filesystem takes that file out of the image and copy it into the differencing layer and store a copy of that file in the container layer. Now the container is only just the running processes and those files different then they were in the base image.

`docker image inspect <NAME>` -- gives metadata, ex exposed ports, environment variables passed in, default command, volumes

### Dockerfile

- Package managers like apt and yum are one of the reasons to build containers from Debian, Ubuntu, Fedora or CentOS.
- TODO Dockerfile commands, 
- You should probably chain bash commands to not to create a new layer for each command. This increases performance.
- Order of the commands matter. The things that will most frequently change should be placed to as bottom as possible.

`docker image build -t custom-nginx .`
`docker image tag customn-ginx custom-nginx:0.01`

### Persistant Data
Ideally your container should not contain unique data mixed in with your application binaries. => seperation of concerns

#### Data Volumes: 
- Creates a special volume outside of that containers union file system to store unique data. We can attach those volumes to whatever container we want.
- If there is a VOLUME command in the Dockerfile of an image, the container will create a permanent data volume when it is run. This volume is not deleted when you remove the container (hence the persistancy).

`docker volume ls` -- list volumes
`docker volume prune` -- prune volumes
`docker container run -detach --name mysql --env MYSQL_RANDOM_ROOT_PASSWORD=yes -v mysql-db:/var/lib/mysql mysql` -- creates named volume
-- if you bind another container with the same name it is bind to the same data volume.
`docker volume create <NAME>` -- create volume ahead of time

#### Bind Mounts: 
- Sharing a host directory or file into a container.
- If you first mount a directory it uses the folder in host (The folder in the container is not touched). If you do not mount anything in the second run, it uses the folder in the container.
`docker container run -detach --name nginx -v $(pwd):/usr/share/nginx/html nginx` -- creates bind mount
- It is generally used for local development and testing.


### Docker Compose
`docker-compose up` -- setup volumes/networks and start all containers
`docker-compose logs`
`docker-compose top`
`docker-compose down` -- stop all containers and remove containers, networks
`docker-compose down -v` -- stop all containers and remove containers, networks and volumes
`docker-compose down -rmi all/local` -- stop all containers and remove containers, networks and images

### Docker Swarm
- Use overlay network to make all services talk to each other with service names
- Routing mesh
    - OS Layer 3 VIP's.

```sh
docker service create --name <name> <image>
docker service ls
docker service ps <name>
```


## Stacks (Swarm with docker-compose files)

```sh
docker swarm init
docker stack deploy -c docker-compose.yml <stack-name>
# starts to create network, volumes, secrets, services in the background
docker stack ls
docker stack ps <stack-name>
docker stack services <stack-name>
```

```yaml
deploy:
    replicas: 2
    update_config:
        parallelism: 2
        delay: 10s
    restart_policy:
        condition: on_failure
        delay: 10s
        max_attempts: 3
        window: 3s
    placement:
        constraints:
            - node.labels.disk == ssd
        # constraints: [node.role == manager]
        # constraints: [node.role != worker]
        # constraints: [node.label == webapp]
        # constraints: [engine.label == webapp]
        preferences:
            spread: node.labels.azone
    mode: replicated
    # mode: global
    labels: [APP=VOTING]
```

## Service updates
```sh
# make a change to docker-compose.yml just rerun
docker stack deploy -c docker-compose.yml <stack-name>
# docker will sync changes by issuing updates. Check manual.
```

- Docker uses rolling updates to apply new settings. 
  **It will replace (stop&start) containers for most updates**
  Therefore you need to have replicas in order to limit downtime.
- Each update is going to impact other things around it differently. 
    - databases, persistant storage
    - web apps with persitant storage such as sockets and long polling
- Preventing downtime is not the job of orchestrator.
- Check rollback and health check options when configuring updates.

- Examples of updates
    - Change image of a service
    - Add a new environment variable
    - Remove a port
    - Change number of replicas

## Secrets

```bash
# from file
docker secret create psql_user psql_user.txt
# not safe as it is. consider getting file from remote.

# from command line
echo 'myDBpass' | docker secret create psql_pass -
# - means read from standard input 
# not safe as people can see bash history
```

```yaml
version: "3.1"

services:
  psql:
    image: postgres
    secrets:
      - psql_user
      - psql_password
    environment:
      POSTGRES_PASSWORD_FILE: /run/secrets/psql_password
      POSTGRES_USER_FILE: /run/secrets/psql_user

secrets:
  psql_user:
    file: ./psql_user.txt
  psql_password:
    external: true
```

- Secrets for local development
    - When you are using `docker-compose` and not `docker-swarm`, compose is also able to process file secrets and but not external secrets. If you are using external secrets you should have different compose files for dev/test and production.

# Health Checks
- You can use execs in the container such as `curl localhost || exit 1` or  etc.
- Three states: starting, healthy, unhealthy.
    - starting is first 3 seconds by default. you can introduce start-period
- Not a replacement with 3rd party monitoring tools.

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost"]
  # test: ["CMD", "pg_isready", "-U", "postgres"]
  interval: 1m30s
  timeout: 10s
  retries: 3
  start_period: 40s
```

## Global Mode
- Deploy service to all nodes considering constaints.
- Mostly for utilities, backup tools, proxy, security, monitoring

## Node Availability

- 3 modes: active, pause, drain
- pause: prevents starting new containers on this node. For trouble shooting
- drain: stops containers on this nodes and assigns tasks to other nodes. For maintainance or rolling update when underlying os changed for ex.

## Logging

- Not for log storage, log searching and creating alarms from logs.
- For troubleshooting (tail)
- 3 options 
    JSON file: Docker will put logs in a local file in local system. default
    journald: 
    ship-your logs off to a 3rd party using a logging driver.
- <https://success.docker.com/article/logging-best-practices>

```yaml
docker service logs <servicename/id>
# fetches logs from other nodes when this command is issued

docker service logs <taskid>

docker service logs --raw --no-trunc --tail 50 --follow <taskid>

```


## Configs


```yaml
version: "3.3"

services:
  web:
    image: nginx
    configs:
        - source: nginx-proxy
          target: /etc/nginx/conf.d/default.conf  # default is root

configs:
  nginx-proxy:
    file: ./nginx-app.conf    # relative to stack file
```

**References**

- <https://speakerdeck.com/alp/istanbul-azure-meetup-docker-talk>
- <https://ahmetalpbalkan.com/blog/herding-code-podcast/>
- [Deni Bertović - Supercharge your development environment using Docker](https://www.youtube.com/watch?v=Z_o5eaNZhZQ)
- <https://medium.com/aws-activate-startup-blog/a-better-dev-test-experience-docker-and-aws-291da5ab1238>
- <https://www.digitalocean.com/community/tutorial_series/the-docker-ecosystem>
- <https://www.udemy.com/docker-mastery>
- <https://docs.docker.com/compose/compose-file/>