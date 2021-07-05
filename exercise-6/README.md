# Exercise 6: building more efficient images
## 6.1 Using caching efficiently

In order to leverage more efficiently the caching mechanism Docker uses when building images, it is important to order commands in your `Dockerfile` so that the commands whose output changes more frequently are executed last. Let's take the `Dockerfile` from a simple Python app (which you created previously, or otherwise you can find it in the resources for this exercise inside the `1-caching` folder) as an example.

1. Build the image once.
1. Build the image again, notice that the second time it was very quick and it was saying `---> Using cache` or `CACHED` in each instruction.
1. Now modify the `server.py` file. Simply change one of the strings.
1. Build the image once more. Notice that it had to install the requirements again, even though they had not changed. This step of installing dependencies can be time consuming and typically changes much less frequently than your code. That is why best practice dictates that you should install dependencies first before copying your actual source code.
1. Modify the `Dockerfile` to copy the `requirements.txt` file (but not the `server.py`), install the dependencies, and then copy the actual application code.
1. As before, try building the image, then change the code in `server.py` and build the image again. Notice how this time, the dependencies are retrieved from cache.

## 6.2 Multi-stage builds

In this exercise we are going to analyze the optimization of an existing dockerized application. Using the example in the `2-multi-stage-builds` folder. Build the image with the supplied file `Dockerfile.1`, and run it. Things to note:
- By default `docker build` looks for a `Dockerfile` in the context folder. If you want to use a different name you can use the `-f` option.
- The application is built in `php`. 
- It runs inside an Apache web server. When requesting the root it displays a welcome message.
- You need to expose port 80 of the container when running the container.

In many languages the requirements to build the application are different to those needed to run it. Multi-stage builds are particularly suited to help reduce the size and complexity of the final image by splitting the build process into separate steps run in different base images.

In this example with `php`, in order to build the application it requires `composer` (the `php` dependency manager). Instead of installing it on the final image, we are going to leverage an existing image that already has it installed.

Try building and running the second version `Dockerfile.2`. Notice that, instead of installing `composer` manually, it uses an existing image with it installed. However, this image does not contain `apache` which is required to run the application. Hence, why the file then has a second `FROM` to load a different image. In line 19, it copies, using the `--from` parameter, the artifacts from the first stage of the build, which was done in the `composer` image, onto the final `php:apache` one.

Build the different Dockerfiles and use `docker history` to examine the resulting images, can you spot the differences?

## 6.3 Dockerize an Angular application

In this exercise you are going to use all your Docker knowledge to create an optimize `Dockerfile` to deploy an angular application inside of an nginx webserver.

Inside the `3-sample-angular-app` folder you will find a very simple angular application. Create a `Dockerfile` inside this folder, to distribute the app so it runs inside `nginx`.

Hints:
- Use one of the official `node` images
- Dependencies are installed running `npm install`. This only requires access to the `package.json` file (and optionally `package-lock.json` if it exists).
- You can build the application using the `npm run build` command. This will build it inside the `/dist/my-app/` folder. For this to work, it requires:
  - all the files from the `src` folder
  - `angular.json`, both `tsconfig` files and `.browserslistrc`
- Distribute the application inside an `nginx` server. By default it serves files it finds in the the `/usr/share/nginx/html/` folder.

Once you are able to build your image successfully, try running the container and opening the sample app in the browser.

## Bonus track

As part of the build process of the Angular app, also ensure all tests are executed. This sample app comes with [Karma](http://karma-runner.github.io/6.3/index.html) already configured and tests can be executed via `npm run test`. However, this requires for the Chrome browser to be installed. Therefore we will need to do the following:

1. Ensure you are base image is `node:14`
1. Create a new stage `test` where you will install Chrome. E.g.
  ```Dockerfile
  RUN apt-get update \
    && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt install -y ./google-chrome*.deb
  ```
1. Set the `CHROME_BIN` environment variable to the location of chrome `/usr/bin/google-chrome`
1. Copy the test configuration files `karma.conf.js` and `tsconfig.spec.json` into the root folder.
1. Run the tests `npm run test -- --no-watch --no-progress --browsers=ChromeHeadlessNoSandbox`
