# Codium Docker training

## Basic commands

- `hello-world.sh`
  - Read the message shown
  - https://hub.docker.com/_/hello-world
- `interactive-ubuntu.sh`
  - https://hub.docker.com/_/ubuntu
  - See how the processes seen inside the container differ from the host.
- `run-command.sh`
  - Example showing the Python version inside a Python container.

### Exercise 1: run command

- `docker run python python --version`
- `docker run -it ubuntu`
- `docker run -it python`
- `docker run --name my-mongo -d mongo`
  - It will run a _mongo_ container _detached_.

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

### Exercise N: check containers are ephemeral

- Every time a container is created, it starts exactly from the same point, i.e. with the file system in exactly the same state as it was defined in the image.
- `docker run alpine sh -c "touch myfile.test && ls"`
  - You have created a file named `myfile.test` and you can see it listed when executing `ls`.
- `docker run alpine ls`
  - You will see the file is no longer there, because you have started a new container! The file was created in the context of a different container, which was stopped and disposed of. When we run the command again, it started from the point of the image, and hence the file we created had disappeared.

### Exercise N: Clean up the system

- `docker container prune`
- `docker image prune`
- `docker volume prune`
- `docker network prune`
- `docker system prune -a`

## TBD

- TBD
