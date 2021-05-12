# Exercise 6: building more efficient images

## Using caching efficiently

In order to leverage more efficiently the caching mechanism Docker uses when building images, it is important to order commands in your `Dockerfile` so that the commands whose output changes more frequently are executed last. Let's take the `Dockerfile` from a simple Python app (which you created previously, or otherwise you can find it in the resources for this exercise) as an example.

1. Build the image once.
1. Build the image again, notice that the second time it was very quick and it was saying `---> Using cache` after each instruction.
1. Now modify the `server.py` file. Simply change one of th strings.
1. Build the image once more. Notice that it had to install the requirements again, even thought they had not changed. This step of installing dependencies can be time consuming and typically changes much less frequently than your code. That is why best practice dictates that you should install dependencies first before copying your actual source code.
1. Modify the `Dockerfile` to copy the `requirements.txt` file (but not the `server.py`), install the dependencies, and then copy the actual application code.
1. As before, try building the image, then change the code in `server.py` and building the image again. Notice how this time, the dependencies are retrieved from cache.

## Multi-stage builds

In this exercise we are going to analyze the optimization ofan existing dockerized application. 
- Start by building an image with the supplied file `Dockerfile.1`, and running it. 
- By default `docker build` looks for a `Dockerfile` in the context folder. If you want to use a different name you can use the `-f` option.
- The application is built in `php`. 
- It executed inside an Apache web server. When requesting the root it displays a welcome message.
- You need to expose port 80 of the container when running the container.

In many languages the requirements to build the application are different to those needed to run it. Multi-stage builds are particularly suited to help reduce the size and complexity of the final image by splitting the build process in separate steps run in different base images.

In this example with `php`, in order to build the application it requires `composer`. Instead of installing it on the final image, we are going to leverage an existing image that it already has it installed.

Try building and running the second version `Dockerfile.2`. Notice that, instead of installing `composer` (the `php` dependency manager) manually, it leverages an existing image with it installed. However, this image does not contain `apache` which is required to run the application. Hence why the file then has a second `FROM` to load a different image. In line 19, it copies using the `--from` parameter, the artifacts from the first stage of the build, which was done in the `composer` image, onto the final `php:apache` one.

Can you see what are the differences with the final version `Dockerfile.3`? Why is it better?