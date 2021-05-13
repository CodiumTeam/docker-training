# Exercise 2: Basic commands

## Exercise 2.1: Running a command inside an ephemeral container

A container is designed to execute a single binary. It is possible to change the command that will get executed by passing parameters to the run docker command.

- Return the working directory inside an alpine container.

  ```bash
  docker run alpine pwd
  ```

- Try to run several commands inside the container:

  ```bash
  docker run alpine pwd ; ls
  ```
  Did it work as expected?
  Docker only takes as a command what you wrote up to the semicolon. The `ls` will be a command in your own local machine, it is not passed to the alpine container.

- In order to run several commands in a container, you can pass them after `sh -c` (it's a common way of running a command with `sh`, very popular in Docker containers).

  ```bash
  docker run alpine sh -c "pwd ; ls"
  ```

## Exercise 2.2: check containers are ephemeral

The filesystem inside a container is ephemeral, any changes to the files are lost when the container exits and is removed.

1. Let's try to create a new file inside a container. 
   ```bash
   docker run --rm alpine sh -c "touch hola.txt && ls"
   ```
   Remember that the container will terminate when the command exits, in this case after creating `hola.txt` and listing the files.

1. Starting a new container based on the same image, notice that `hola.txt` is no longer there, as it disappeared when the previous container terminated.
   ```bash
   docker run --rm alpine sh -c "ls"
   ```

## Exercise 2.3: practice with run, logs, ps

#### docker ps
It is very useful to see what containers you have running at any one time. This is done with the `docker ps` command.

1. Let's start by checking the running containers. If you followed the previous exercises, you should not have any containers running (if you are using Windows you may see Mongo still running).
   ```bash
   docker ps
   ```
2. However if you pass the `-a` flag, it will also return the containers that are no longer running, but have not yet been removed. 
   ```bash
   docker ps -a
   ```
   Notice that some of the containers you executed before are listed there. Each was given a random name.
3. You can individually remove each of those containers using their name, their ID, or even the first few characters of their ID
   ```bash
   docker rm [container-name]
   ```
   Alternatively, you could use the flag `--rm` in the `docker run` command. The container is then automatically removed as soon as it stops, so you will not see it listed when doing `docker ps -a`.

#### docker logs

You can access the logs of a container while it is running, or even after it has stopped; but never after it is removed removed. The one downside of using the `--rm` flag is that if something goes wrong inside the container and it terminates unexpectedly you will not be able to see the logs and find out what happened.

As an example:

1. Create a MongoDB container in detached mode, with name `my-mongo`:
   ```bash
   docker run -d --name my-mongo mongo
   ```
2. Show the running container. Notice the info shown.
   ```bash
   docker ps
   ```
3. Show the logs generated for the running Mongo container
   ```bash
   docker logs my-mongo
   ```
4. If you kill the container (we are simulating there was an error), you can see the logs are still accessible.
   ```bash
   docker kill my-mongo
   docker ps -a
   docker logs my-mongo
   ```

5. If you then remove the container, the logs are no longer visible.
   ```bash
   docker rm my-mongo
   docker ps -a
   docker logs my-mongo
   ```

#### stopping/removing several containers
If you want to stop or remove many running containers you can leverage the `-q` flag (`quiet` mode) of the `ps` command
   ```bash
   docker ps -aq
   ```
1. For example, you can delete all the existing containers, no matter their status:
```bash
docker ps -aq | xargs docker rm -f
```

   Windows Powershell version:
   ```powershell
   docker ps -aq | % {docker rm -f $_}
   ```
2. Verify there are no containers left
    ```bash
    docker ps -a
    ```

## Exercise 2.4: Run commands in an already running container

You can execute extra commands in a running container. However this is not normally necessary, except for debugging, or sometimes to leverage an existing tool in the container. You should never modify your running container as if it was a VM, as it is ephemeral and it will disappear when it terminates. Any extra tools or changes need to be added to the image, never to the container.

That said, executing commands in a running container is a vital debugging tool when the container is not behaving as expected.

In this exercise we will try to use the `mongo CLI` tool which is installed inside the mongo container.

1. Run a new Mongo container in detached mode
   ```bash
   docker run -d --rm --name my-mongo mongo
   ```
2. Execute the command `mongo --help` on the running container
   ```bash
   docker exec my-mongo mongo --help
   ```
3. Insert a new document inside a new `users` collection
   ```bash
   docker exec my-mongo mongo --eval "db.users.insertOne({name: 'jonas'})"
   ```
4. Show all the existing documents inside the `users` collection
   ```bash
   docker exec my-mongo mongo --eval "db.users.find()"
   ```
5. Connect to the Mongo container in an interactive way
   ```bash
   docker exec -ti my-mongo mongo
   ```
   5.1. Inside the container, show all the existing documents
   ```bash
   db.users.find()
   ```
   5.2. Exit the container
   ```bash
   exit
   ```
6. Show the last 3 logs generated by the Mongo container
   ```bash
   docker logs -n 3 my-mongo
   ```
7. Stop and remove the running container
   ```bash
   docker rm -f my-mongo
   ```

## Bonus track

### Filter the existing containers

You can also filter the output of the `docker ps` command for example to show: 
- Filter and show only the containers which name contains the word _mongo_.
   ```bash
   docker ps --filter name=mongo
   ```
- Show only the containers with an exit code `0`.
   ```bash
   docker ps -a --filter exited=0
   ```
- Show only the containers which are in a specific status (e.g. running, created, 
   ```bash
   docker ps --filter status=running #exited, restarting, etc.
   ```

You can combine this with with `-q` to show all containers that exited successfully. Try to create a command that will remove all such containers. 

### Stopping containers

- Another way of stopping all containers (does not work in Windows DOS).
  ```bash
  docker stop $(docker ps -qa)
  ```
- Remove all stopped containers (does not work in Windows DOS).
   ```bash
   docker rm $(docker ps --filter status=exited -q)
   ```
### Play with the logs command
You can see the `logs` command has some useful flags `docker logs --help`.

Start a new new Mongo container in detached mode and:
- Show the current logs.
  ```bash
  docker logs my-mongo
  ```
- Follow the logs (shown in real time).
  ```bash
  docker logs my-mongo -f
  ```
  - You can exit just typing Control+C
- Show the logs with a timestamp at the beginning of each line.
  ```bash
  docker logs my-mongo --timestamps
  ```
- Show the logs generated during the last 5 minutes.
  ```bash
  docker logs --since 5m my-mongo
  ```
- Show the last 10 lines of logs.
  ```bash
  docker logs --tail 10 my-mongo
  ```
