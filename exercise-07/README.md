# Exercise 7: using Docker in your development environment

Traditionally, a lot of time is wasted when a new developer starts in a project and needs to configure their computer with the required tools and dependencies. In addition, over time, you will find they are using different versions of tools, libraries, etc., creating further disparities in the way the software is run in each developer's machine.

The aim is always to have Docker as the **only** dependency in the developer's machine.

In this exercise you will add the necessary configuration to use Docker during the development process, so nothing else needs to be installed on the developer's machine.

## 7.1 Running the application

The purpose is to run an Angular application, with hot reload, so it shows in the browser and updates automatically when the code changes.

> If you are using Windows, the recommended approach would be to install a WSL2 distribution (like Ubuntu), and do the exercise from inside the Linux terminal. This can be opened using Microsoft+R and typing `wsl`.

Go to the `exercise-07/project` folder and create a new `docker-compose.yml` file. Add a service called `app` with the following details: 
- builds the stage `base` of the `Dockerfile` in the root
- overrides the command to be `[ 'npm', 'start', '--', '--host=0.0.0.0', '--disable-host-check']`
- exposes the port 4200
- mounts the current folder in the `/app` folder inside the container.
- mounts a volume `/app/node_modules`. Yes, just that path, there is no `source:target` format in this case. This means it will mount the components of the `/app/node_modules` folder *from the image* into the *container*. This is required because otherwise you would lose the `node_modules` folder when you mount the source of the application.

> Why is the `--host=0.0.0.0` flag required? By default, when serving in development mode the app is only served via the localhost interface. In this case you may think that is what we are doing because you are opening `localhost` in the browser.  However, the browser is running in the host, and when it arrives to the container via port exposing, is coming through a non-local network interface. This is a common issue when working with containers in development.

Once the file is ready bring it up by running `docker compose up`. After the compilation is finished, open the browser to show [http://localhost:4200](http://localhost:4200). You should see the Angular application.

If you modify the title of the application in the `src/app/app.component.html` file you should see it refresh in the browser straight away. 
> If your files are in a non-Linux partition (i.e. Windows or Mac) you will need to add an extra option to the start command: `[ 'npm', 'start', '--', '--host=0.0.0.0', '--disable-host-check', '--poll', '2000']`, so it uses polling for file changes.

Bring the stack down pressing `Ctrl+C` in the terminal where you started it up.

## 7.2 Running the tests

There are many alternatives for running the tests, but in this case you are going to create another service in the docker compose named `test` configured as follows:
- builds the stage `test` of the `Dockerfile` in the root
- overrides the command to be `[ '--browsers=ChromeHeadlessNoSandbox' ]`
- mounts two volumes 
  ```yaml
   - .:/app:cached
   - /app/node_modules
  ```
- exposes port 9876

Restart the stack running `docker compose up -d`. You can now see the tests running `docker compose logs test`. Remember from earlier modules you can pass an option to the logs command to keep it open and *follow* the logs.

The tests may be failing right now because of the change you made earlier to the `src/app.component.ts` file. Undo the change to see the tests pass.

> If your files are in a non-Linux partition (i.e. Windows or Mac) you will need to add an extra option to the start command: `[ '--browsers=ChromeHeadlessNoSandbox', '--poll', '2000']`, so it uses polling for file changes.

Alternatively you can also see the tests in the browser by opening [http://localhost:9876](http://localhost:9876).

## Bonus track 

### Using VS Code Remote Containers extension

If you are using Visual Studio Code, you can benefit from their support of Docker containers, and simplify the set up significantly.

1. Ensure the *Remote - Containers* (`ms-vscode-remote.remote-containers`) extension is installed in VS Code.
1. Open the `exercise-07/project` in VS Code.
1. In left corner of the status bar of VS Code there should be a blue squared area, click there, and in the menu select **Add Dev Container Configuration Files...**
1. Select **Add configuration to workspace** 
1. Select **From a predefined container configuration definition...**
1. Select **Node.js & Typescript** (if asked to trust the autor say yes)
1. Select version **20-bookworm**
1. Skip the selection of additional features to install, just press the blue OK button 
1. Uncomment the *forwardPorts* section and add 4200 to the array.
1. Save the file.
1. From the blue area in the status bar, click and select **Reopen in container**

1. Open a terminal `Ctrl+J`
1. Install dependencies executing `sudo npm install`
1. Start the application `sudo npm start -- --host=0.0.0.0`
1. Open a browser to show [http://localhost:4200](http://localhost:4200) (actually VS Code will prompt you to do so, after the application is compiled)

### Running tests
1. In order to execute the tests we need to modify the development image to add Chrome. Open the `.devcontainer/Dockerfile` file and add the following lines at the end of the file
  ```Dockerfile
    RUN apt-get update \
      && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
      && apt install -y ./google-chrome*.deb \
      && rm google-chrome-stable_current_amd64.deb
    ENV CHROME_BIN=/usr/bin/google-chrome
  ```
  This will install Chrome so we can execute the tests. 
1. Click on the status bar, on the green area which says `Dev Container: Node.js` and select **Rebuild Container**.
1. Once VS Code restarts, open a new terminal and execute the tests typing `npm test -- --browsers=ChromeHeadlessNoSandbox`. Start the brwoser on [http://localhost:9876](http://localhost:9876).

The advantage of running using the remote development features of VS Code is that all the extensions will work normally. In fact you could use the `.devcontainer/devcontainer.json` file to define extra setttings and extensions that should be enabled just for working with this particular project. This is very useful as it allows tailoring the behaviour of the IDE to the project, and also homogenize the extensions in use amongst all team members.
