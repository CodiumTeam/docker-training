# Jenkins with docker
Starts a Jenkins environment connected to a Docker in Docker so it can build and push Docker images

## Start

```
  docker-compose up -d
  docker-compose logs executor
```

```
  docker-compose exec executor cat /var/jenkins_home/secrets/initialAdminPassword
```