# Basic commands

## Example 1: run an ephemeral container

1. On a terminal, run 
   ```bash
   docker run hello-world
   ```
1. Carefully read and understand all the steps shown that have been executed
   - It downloaded the image 'hello-world' from the [official Docker registry](https://hub.docker.com/_/hello-world)
   - Printed some text messages in the terminal
   - It stopped

## Example 2: run a long-lived container

1. On a terminal, run 
   ```bash
   docker run mongo
   ```
1. This command:
   - Downloaded a [mongo image](https://hub.docker.com/_/mongo)
   - Ran a new Mongo server (you can see the logs in the standard output)
1. You can stop it just with `Control+C`

## Bonus track

- Run a Python container and show the Python version: 
   ```bash
   docker run python:alpine python --version
   ```
- Run an Ubuntu container and list the directory contents: 
   ```bash
   docker run ubuntu ls
   ```
- Run a REPL for Python (latest version): 
   ```bash
   docker run -it python:alpine
   ```
