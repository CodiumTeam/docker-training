# Jenkins with docker
Starts an environment to play with Jenkins and continuous integration pipelines. It boots the following services:

| Service          | URL                   | Description                                                                        |
|------------------|-----------------------|------------------------------------------------------------------------------------|
| executor         | http://localhost:8080 | Runs the Jenkins automation server                                                 |
| gogs             | http://localhost:3000 | [Gogs](https://github.com/gogs/gogs), an open source Github alternative            |
| registry         | http://localhost      | Front end to visualize on the browser the contents of the image registry           |
| registry-backend |                       | Docker registry to pull and push images                                            |
| docker           |                       | Docker in docker container to build and execute docker images during the pipelines |

## Start

To start the stack:
```
  docker compose up -d
```

You can find out the admin password for Jenkins by running:
```
  docker compose exec executor cat /var/jenkins_home/secrets/initialAdminPassword
```




