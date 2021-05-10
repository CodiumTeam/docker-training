# Exercise 2: Basic commands

## Exercise 2.1: Running a command inside an ephemeral container

A container is designed to execute a single binary. It is possible to change the command that will get executed by passing parameters to the run docker command.

- Return the working directory inside an alpine container.

  ```bash
  docker run --rm alpine pwd
  ```

  Because of the flag `--rm`, the container will be removed after running the desired command (you won't see it with `docker ps -a`).

- Try to run several commands inside the container (it will fail):

  ```bash
  docker run --rm alpine pwd; ls
  ```

  The reason why it fails is that Docker only takes as a command what you wrote up to the semicolon. The `ls` will be a command in your own local machine, it is not passed to the alpine container.

- In order to run several commands in a container, you can pass them after `sh -c` (it's a common way of running a command with `sh`, very popular in Docker containers).

  ```bash
  docker run --rm alpine sh -c 'pwd; ls'
  ```

## Exercise 2.2: practice with run, logs, ps, start and stop

- Create a MongoDB container in detached mode, with name `my-mongo`:

```console
$ docker run -d --name my-mongo mongo
```

- Xxxx

```bash
docker run -d --name my-mongo mongo

docker ps

docker logs my-mongo

docker run -d --name another-mongo mongo

docker ps

docker stop another-mongo

docker ps

docker ps -a

docker start another-mongo

docker ps -q

docker ps -q | xargs docker stop

docker ps -a

docker ps -q | xargs docker rm
```

## Exercise 2.3: Run commands in an already running container

```bash
docker run -d --rm --name my-mongo mongo
docker exec my-mongo mongo --help
docker exec my-mongo mongo --eval 'db.getCollectionNames()'
docker exec my-mongo mongo --eval 'db.users.insertOne({name: "jonas"})'
docker exec my-mongo mongo --eval 'db.getCollectionNames()'
docker exec my-mongo mongo --eval 'db.users.count()'
docker exec my-mongo mongo --eval 'db.users.find()'
docker exec my-mongo -ti mongo
   db.users.find()
   exit
docker logs -n 3 my-mongo
docker stop my-mongo
```

## Exercise N: check containers are ephemeral

The filesystem inside a container is ephemeral.

```bash
docker run -d --name long-running alpine sleep 1000
docker ps
docker exec long-running touch foobar
docker exec long-running ls foobar
docker stop long-running
docker start long-running
docker exec long-running ls foobar
docker kill long-running
docker run -d --name long-running alpine sleep 1000
docker exec long-running ls foobar
```

## Bonus track

### Filter the existing containers

- `docker ps -a`: to see all containers in any state (not only running)
- `docker ps --filter "name=mongo"`: filter and show only the containers which name contains the word _mongo_
- `docker ps -a --filter 'exited=0'`: show only the containers which exit code was `0`.
- `docker ps --filter status=running`: show only the containers which are in a specific status (e.g. running, created, exited, restarting, etc.).

### Stopping containers

- Stop all containers: `docker stop $(docker ps -qa)`
- Remove all stopped containers: `docker rm $(docker ps --filter status=exited -q)`

### Play with the logs command

- Run a new Mongo container in detached mode: `docker run -d --name my-mongo mongo`
- Show the current logs: `docker logs my-mongo`
- Follow the logs (it will be shown in real time): `docker logs my-mongo -f`
  - You can exit just typing Control+C
- Show the logs with a timestamp at the beginning of each line: `docker logs my-mongo --timestamps`
- Show the logs generated during the last 5 minutes: `docker logs --since 5m my-mongo`
- Show the last 10 lines of logs: `docker logs --tail 10 my-mongo`
