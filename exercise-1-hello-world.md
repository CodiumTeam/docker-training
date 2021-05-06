# Hello world

## Example 1: run an ephemeral container

1. On a terminal, run `docker run hello-world`
1. Carefully read and understand all the steps shown that have been executed
   - Specially remark how it downloaded the image 'hello-world' from the [official Docker registry](https://hub.docker.com/_/hello-world)
1. This container just printed those text messages in the terminal and then it stopped.

## Example 2: run a long-lived container

1. On a terminal, run `docker run mongo`
1. This command:
   - It downloaded a [mongo image](https://hub.docker.com/_/mongo)
   - It run a new Mongo server (you can see the logs in the standard output)
1. You can stop it just with Control+C

## More simple examples that you can try

- Run a Python container and show the Python version: `docker run python:alpine python --version`
- Run an Ubuntu container and list the directory contents: `docker run ubuntu ls`
- Run a REPL for Python (latest version): `docker run -it python:alpine`
