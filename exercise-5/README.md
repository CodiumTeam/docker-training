# Exercise 5: how to build your own image

## 5.1 Building a Dockerfile: a very simple Python app

For this exercise, you are given a very simple Python application, which runs a small flask web server. You are going to create an image to package this application, so it can run executed with Docker.

### Steps

1. Start by creating a `Dockerfile` inside the folder `flask-example` of the given Python application.
2. Add an instruction to base your image in the official Python image for version `3.9`. Remember it is a good practice to *pin* the base image to a particular version, to avoid unexpected version changes in the future.
3. This application only requires the files `requirements.txt` and `server.py` to run. Copy them into the image. 
4. Add a command statement to specify what binary should be executed when the image is started as container. The python application is started by running `python server.py`.
5. In order to try the image, you need to first build it:
   ```bash
   docker build -t my-python-app .
   ```
   Note we are tagging the image with a name using the `-t` option.
6. Start a container based on the image you just created: 
   ```bash
   docker run -p 9090:9090 -d my-python-app
   ```
   Check the logs to see if it works.

   Notice that the application is giving an error. This is because it has a dependency on the framework [**Flask**](https://flask.palletsprojects.com/en/1.1.x/). This is not installed by default in the python image, so you need to add it to your `Dockerfile` so it gets installed during the image build process. Remember that your image needs to have all the required pieces in order to run your application autonomously. 

1. Modify your Dockerfile to install the dependencies. The command line to use is 
   ```bash
   pip install -r requirements.txt --no-cache-dir
   ```

   > By default, `pip` will keep a global cache in case you want to install the same module in a different project later on. Since the sole purpose of this docker image is to run your application, you will never need to install any extra modules. This is why we add `--no-cache-dir` option is added, to disable the cache and ensure the image is as small as possible.

1. Build and run the image again. 
1. Check the logs to see if it is working correctly now.
1. Access http://localhost:9090 in your browser and verify the app responds correctly.

### Further improvements

#### WORKDIR

You can fix the default working directory during the build process. This is done with the `WORKDIR` command. This has the advantage that you can have relative paths in your statements (e.g. `COPY`, `RUN` etc.) and you can change the location in a single place. 
Modify the `Dockerfile` to leverage this feature.

#### ENV

This particular python app, is configured to respond on port 9090. However you could override this port via an environment variable. You could do this when running the container: `docker run --rm -d -p 9090:8080 -e FLASK_SERVER_PORT=8080 my-python-app`. However, you could also give a default value to this environment variable inside the Dockerfile. You could then override the default port 9090, when the container is started without specifying a value for the `FLASK_SERVER_PORT` variable.
Modify the `Dockerfile` to use port 8080 by default.

#### ARG
Sometimes it is useful to parametrize certain values in your `Dockerfile`. For example we may want to build two versions of the image, one for Python 3.9 and another one for Python 3.8. In order no to have two dockerfiles, we can parametrize the image version.

1. At the top of your `Dockerfile` add a new instruction `ARG VERSION=3.9-alpine`. Notice how we are able to give it a default value.
1. In the `FROM` instruction now replace the tag with the variable `$VERSION`.
1. If you build the image normally it will use the argument's default value. In order to override it you can pass it in the build command.
   ```bash
   docker build -t my-python-app --build-arg VERSION=3.8-alpine .
   ```

   > Notice that we put the `ARG` instruction at the top of the file, before `FROM`, as we wanted to use it as part of the `FROM`. `ARG` is one of the few commands that can go above `FROM`. 

   We could also parametrize the default value for the `ENV` statement. You can try adding another arg `PORT` with a default value, which then you can use to pass a value to `ENV`.

   It is important to note that in this case the `ARG` keyword must go **after** the `FROM`, as you want to use it inside the image that is being built.

#### EXPOSE

If you try to start your image with automatic port allocation:
```bash
docker run --rm -d -P my-python-app
```
you will see despite using `-P` no ports have been exposed locally. This is because the `-P` option automatically exposes any ports as long as they have been **declared** in the `Dockerfile`. Try modifying the `Dockerfile` to expose the port of the python application automatically when using `-P`.

## 5.2 ENTRYPOINT vs CMD

The binary to be executed when the container starts is defined by the concatenation of both `ENTRYPOINT` and `CMD` properties. When you execute the `docker run` command you are able to change the value of the `CMD` part.
1. Switch to the `entrypoint-cmd` folder.
1. Build the sample `Dockerfile`:
   ```bash
   docker build -t entrypoint-cmd-example .
   ```
1. Start the container:
   ```bash
   docker run entrypoint-cmd-example
   ```
   Notice how `CMD` is the argument passed to the binary command defined as `ENTRYPOINT` in this case is executing `/bin/cat /etc/os-release`.
1. You can override the command adding an extra argument:
   ```bash
   docker run entrypoint-cmd-example /etc/passwd
   ```
1. You can also override the entrypoint in the following way:
   ```bash
   docker run --entrypoint ls entrypoint-cmd-example /etc/passwd

## 5.3 Using Docker to run the Angular CLI

As we have established, we use a container to run a process in an isolated manner. This process could be a long-lived application like a web server or a database, or short-lived like invoking a command in a CLI.

In this exercise you will create a Docker image to run the [Angular](https://angular.io/) CLI. From a development perspective this means you don't have to worry about installing all the dependencies of the CLI (for example, node), and you can easily use multiple versions of the CLI at the same time.

Hints:
- Use a base image that already has node installed, e.g. `node:14-alpine`. You would prefer an `alpine` version to ensure the size of the image is quite small.
- The angular CLI can be installed running `npm install --global @angular/cli@12.0.5`
- Name the image `ng:12`
- This CLI uses `git` commands in some operations. You can install git in the image too doing:
```Dockerfile
   RUN apk --update add \
        git \
        less \
        openssh \
    && rm -rf /var/lib/apt/lists/* \
    && rm /var/cache/apk/*
```
- Set the starting process of the image to be `ng`. Since this is a CLI you will need to add different parameters (e.g. `ng add` or `ng build`) when running the container. Should you use the `ENTRYPOINT` or `COMMAND` directive in the Dockerfile?

After building the image you can try it running `docker run --rm ng:12 version`. You should see the output from the CLI.

### Creating a new project

We are now able to use our new image to create a new Angular project. How should you do it?
```
docker run --rm -v ${PWD}:/app -w /app -t -i ng:12 new sample-project --skip-install
```

As explained earlier, the Angular CLI uses git commands to start a new repository when it creates a new project. To use the existing git settings (particularly email and name) we can simply mount the `.gitconfig` file from our home folder into the home folder of the container.

> Usually the global `.gitconfig` file is located at `${HOME}/.gitconfig` but sometimes can be at `${HOME}/.config/git/config`, use the appropriate location in the following commands.

```
docker run --rm -v ${PWD}:/app -w /app -t -i -v ${HOME}/.gitconfig:/root/.gitconfig:ro ng:12 new sample-project --skip-install
```

## Bonus track

### Changing the USER

If you are using Linux (either natively or inside the terminal of Windows WSL2), you may notice the Angular seed project files have been created with the wrong owner and group. You can verify it running `ls -l`. You should see the owner of the files is `root`. What has happened? By default the Docker daemon runs as root, and if we don't add some extra options to either the `run` command or the `Dockerfile`, the container will run as root.

Many official images already provide a non-root user that can be used inside the container. In this case the `node` image has a `node` user. 
```
docker run --rm --user node -v ${PWD}:/app -w /app -t -i -v ${HOME}/.gitconfig:/home/node/.gitconfig ng:12 new sample-project --skip-install
```

As an alternative to this, we could add a `USER node` directive at the end of the `Dockerfile`. You would need to rebuild the image and try running the `run` command without the `--user` parameter.

> Note, usually the default user in Linux has the id 1000 which is the same as the one given to the _node_ user inside of the `node` container. Since the ids match, the files are owned by your default account in the host OS. If your user account in the host has a different id, you would need to use a different id

### Alias

Running the very long `docker run` is inconvenient, so an easier way is to create an alias:

In Linux bash:
```bash
alias ng='docker run --user node -v ${PWD}:/app -w /app -ti --rm -v ${HOME}/.gitconfig:/home/node/.gitconfig:ro ng:12'
```

Or in (Windows) Powershell you can create a function
```
function ng () { docker run --user node -v ${PWD}:/app -w /app -ti --rm -v ${HOME}/.gitconfig:/home/node/.gitconfig:ro ng:12 @Args }
```

This allows you to invoke the Angular CLI as if it was installed locally, e.g. `ng version` or `ng new project --skip-install`

   ```
## Resources

- https://github.com/jessfraz/dockerfiles
- https://hub.docker.com/
- https://yodralopez.dev/docker-cheatsheet-v2.pdf
