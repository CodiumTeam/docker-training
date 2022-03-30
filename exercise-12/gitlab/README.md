# Exercise 12: Pipelines

In this exercise you will configure a continuous integration pipeline. The purpose is: build an image with your code, test it, and then push it to a registry. 

## 12.1 Building a Python app

To do this you will use an automation tool for executing pipelines named [Gitlab](https://www.gitlab.com/). 

### Create a new Repository on Gitlab

#### Sign in or create an account
[Sign in](https://gitlab.com/users/sign_in) (or [sign up](https://gitlab.com/users/sign_up) if you don't have a gitlab account).

If you see *Start your Free Ultimate Trial* click "Skip Trial" on the bottom of the page.

If you have created a new account using a third party authentication system you will need to [add an SSH Key](https://gitlab.com/-/profile/keys) or [set a password](https://gitlab.com/-/profile/password/reset)


#### Create New repository on Gitlab

1. Create a *New Project*
2. Click *Create blank project*
3. Add a *Project name*
4. Unmark *Initialize repository with a README* inside *Project Configuration*
5. Click *Create project*
6. Keep the page with the instructions adapt the following commands

#### Push code into Gitlab
1. Open a terminal in the `./exercise-12/1-python` folder.
2. Follow the instructions on *Push an existing folder*, that should be something like (please, ignore the *cd* command):
    ```bash
      git init
      git add .
      git commit -m "first commit"
      git remote add origin <repository url>
      git push -u origin master
    ```
3. Check that the code is on Gitlab; if you reload the project page you should see the files.

### Configure the pipelines

#### Check the first execution

1. Check the first Pipeline execution on Gitlab: click on *CI/CD* at the sidebar.
2. Open a Pipeline by clicking on status *passed*  
3. Open each job to see what happens

#### Build the image at build stage

Replace the echo instruction in the `.gitlab-ci.yml` to build the flask image. 
Commit and push the change and verify if the pipeline successfully builds the Docker image.

Hints:
  - You will need to use an image that supports docker-compose like `docker/compose`.
  - You will need to define a docker-in-docker *service*.
   ``` yaml
   services:
     - docker:19.03.12-dind
   ```

You may want to enable docker build kit. Take a look to *DOCKER_BUILDKIT* and *COMPOSE_DOCKER_CLI_BUILD* *variables*. 

#### Publish the image at build stage

Next you will modify the `.gitlab-ci.yml` so the image is pushed to the registry. 

Hints:
  - You need authenticate in the registry before being able to push the image. The credentials are username `$CI_REGISTRY_USER` password `$CI_REGISTRY_PASSWORD`.
  - The registry URL is `$CI_REGISTRY`
  - You may want to tag the image with the short SHA of the current commit `$CI_COMMIT_SHORT_SHA`
  - The image name can be `$CI_REGISTRY_IMAGE`

When you finally get the build stage to correctly push the images to Gitlab you can check the registry at *Packages & Registries* - *Container Registry*

### Use environment variables

You may want to add some Variables on Gitlab to avoid commit sensitive data to the repository.

You can define it on *Settings* - *CI/CD* - *Variables* - *Expand* - *Add variable*.

## 12.2 Building an Angular app

In this exercise you will practice how to parallelize pipeline steps and execute tests by running a Docker container and uploading the results as an asset.

### Set up the project

`exercise-12/2-angular`

TBD in 

### Build and execute Karma tests

If you inspect the `Dockerfile` in this Angular project, you will notice it follows the builder pattern with a multi-stage process. 
It has several stages:
1. *Base*: installs dependencies and copies the source code.
1. *Test*: adds an installation of Chrome and other files required for executing tests.
1. *Build*: builds the angular application creating a series of javascript, css and html assets.
1. *Final*: copies the build output onto a nginx instance.

Notice the final output is an `nginx:alpine` image, which is therefore small, and does not contain any of the dependencies that were needed to build and test the application.

You are able to build up to a particular stage using the `--target` flag of the `docker build` command. 

If you want to create an image that can be used to test the application you can execute:
```bash
    docker build -t my-angular-app:test-latest --target test .
```
You can then use this image to invoke the tests:
```bash
    docker run --rm -v ${PWD}/karma-tests:/app/karma-tests my-angular-app:test-latest
```
You can try executing the tests locally running those lines in the command line. Notice how the volume mount is used to extract the test report file, which will now be available in the `karma-tests` folder.

Modify the test stage of the Gitlab pipeline to execute the tests.

Make a commit and push the changes to start the pipeline, and check all tests pass successfully.

### See the tests integrated with Gitlab

Since the tests create a `junit` format report, you could expose it in the Gitlab UI, so it is easier to inspect the test results.

Extend the `test` step:
```yaml
   artifacts:
      when: always
      paths:
         - karma-tests/results.xml
      reports:
         junit: karma-tests/results.xml
```

If you commit and push again, you will notice that in the *Pipeline* report in the Test tab, you can see the test results.

![Test results](TBD)

### Build and release the application

Complete the build and release stages to build the production image and upload it to the registry, just like you did earlier with the Python application.

### Parallelize stages

TBD


# Bonus track

Add an extra step in the build stage, to execute a docker scan of the image.

You will need to be logged in to *Docker Hub*, so you will need to execute a docker login statement. Do not put the credentials in the `.gitlab-ci.yml` and store them in Gitlab, just as you learnt earlier.

If you have used all your free *Snyk* scans, you may need to also login to *Snyk* and add an API token.
