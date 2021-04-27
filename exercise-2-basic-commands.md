# TBD

docker run -it ubuntu bash

docker run -it python python --version

- `hello-world.sh`
  - Read the message shown
  - https://hub.docker.com/_/hello-world
- `interactive-ubuntu.sh`
  - https://hub.docker.com/_/ubuntu
  - See how the processes seen inside the container differ from the host.
- `run-command.sh`
  - Example showing the Python version inside a Python container.

### Exercise 2: ps command

- `docker ps`
  - Check that there is a container running with name `my-mongo`
- We can run so many containers from an image as we want.
  - E.g. to run another mongo container: `docker run --name another-mongo -d mongo`
- `docker ps -a`: to see all containers in any state (not only running)
  - E.g. you should see the Python containers from the previous exercise in "Exited" status.
- `docker ps --filter "name=mongo"`: filter and show only the containers which name contains the word _mongo_
- `docker ps -a --filter 'exited=0'`
- `docker ps --filter status=running`

### Exercise 3: rm command

- `docker run --rm python python --version`
  - This time, a new container runs showing the version but it gets deleted as soon as it exits (you won't see it with `docker ps -a`)

### Exercise 4: stop/start/kill/restart/rm command

- Stop all containers: `docker stop $(docker ps -qa)`
- Remove all stopped containers: `docker rm $(docker ps --filter status=exited -q)`

### Exercise 4: exec command

1. `docker run --name ubuntu_bash --rm -i -t ubuntu bash`
1. `docker exec -d ubuntu_bash touch /tmp/execWorks`
1. Inside the first container, run `ls`, you should see the new file `execWorks` under /tmp.
1. Se puede jugar con el sleep también para ver el proceso con ps.
1. Working directory: `docker exec -it -w /root ubuntu_bash pwd` vs `docker exec -it ubuntu_bash pwd`

- COMMAND will run in the default directory of the container. If the underlying image has a custom directory specified with the WORKDIR directive in its Dockerfile, this will be used instead.

### Exercise 4: run command

TBD

### Exercise 4: logs command

- `docker logs my-mongo`
- `docker logs my-mongo -f`
- `docker logs my-mongo --timestamps`
- `docker logs --since 5m my-mongo`
- `docker logs --tail 10 my-mongo`
- docker run --name test -d busybox sh -c "while true; do $(echo date); sleep 1; done"
- docker logs -f --until=2s test

### Exercise N: check containers are ephemeral

- Every time a container is created, it starts exactly from the same point, i.e. with the file system in exactly the same state as it was defined in the image.
- `docker run alpine sh -c "touch myfile.test && ls"`
  - You have created a file named `myfile.test` and you can see it listed when executing `ls`.
- `docker run alpine ls`
  - You will see the file is no longer there, because you have started a new container! The file was created in the context of a different container, which was stopped and disposed of. When we run the command again, it started from the point of the image, and hence the file we created had disappeared.
