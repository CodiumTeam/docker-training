# Exercise 5: how to build your own image

## 5.1 Building a Dockerfile

For this exercise, you are given a very simple Python application, which runs a small flask web server. You are going to create an image to package this application, so it can run by doing `docker run`.

### A very simple application

1. Start by creating a `Dockerfile` inside the folder `flask-example` of the given Python application.
2. Add an instruction to base your image in the official Python image for version `3.9`. Remember it is a good practice to *pin* the base image to a particular version, to avoid unexpected version changes in the future.
3. Copy the two files required for the application in to your image
4. Add a command statement to specify what binary should be executed when the image is started as as container. The python application is started by running `python server.py`.
5. In order to try the image, you need to first build it:
   ```bash
   docker build -t my-python-app .
   ```
   Note we are tagging the image with a name using the `-t` option.
6. Start a container based on the image you just created: 
   ```bash
   docker run -p 9090:9090 -d --name app my-python-app
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

This particular python app, is configured to respond on port 9090. However you could override this port via an environment variable. You could do this when running the container: `docker run --rm -d -p 9090:8080 -e FLASK_SERVER_PORT=8080 --name my-app my-python-app`. However, you could also give a default value to this environment variable inside the Dockerfile. You could then override the default port 9090, when the container is started without specifying a value for the `FLASK_SERVER_PORT` variable.
Modify the `Dockerfile` to use port 8080 by default.

#### ARG
Sometimes it is useful to parametrize certain values in your `Dockerfile`. For example we may want to build two versions of the image, one for Python 3.9 and another one for Python 3.8. In order no to have two dockerfiles, we can parametrize the image version.

1. At the top of your `Dockerfile` add a new instruction `ARG VERSION=3-alpine3.9`. Notice how we are able to give it a default value.
1. In the `FROM` instruction now replace the tag with the variable `$VERSION`.
1. If you build the image normally it will use the argument's default value. In order to override it you can pass it in the build command.
   ```bash
   docker build -t my-python-app --build-arg VERSION=3-alpine3.8 .
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

## Bonus track

### ENTRYPOINT vs CMD

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
   ```

## Resources

- https://github.com/jessfraz/dockerfiles
- https://hub.docker.com/
- https://yodralopez.dev/docker-cheatsheet-v2.pdf
