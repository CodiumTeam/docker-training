# Docker Compose exercises

## How to use an existing docker compose

- The goal of this exercise is to xxx
- https://github.com/docker/awesome-compose/blob/master/nginx-flask-mongo/README.md
- Go to the folder `exercise-4` move into the folder `nginx-flask-mongo`
- xxxxx
  ```bash
  docker-compose up
  ```
- In a different terminal, check that two services are up and running:
  ```bash
  docker ps
  ```
  Con foco xxxxx:
  ```bash
  docker-compose ps
  ```
- Access the URL http://localhost:80 and check that it works (you should see xxx)
- `docker-compose logs`

## Create your own docker-compose.yml to run a single service

- The goal of this exercise is to convert the `docker run` for nginx that we used in the [exercise-3](./exercise-3-ports-envs-volumes.md) to a simple docker-compose.
- Important: we usually use docker-compose.yml for defining more complex scenarios, usually with 2 or more services (not just one like this example). This exercise with a single service docker-compose.yml is intended for pedagogical goals. La sintaxis es más beneficiosa que xxx
- Please, transform the next docker run into a docker-compose.yml and verify that it works as expected:
  ```bash
  docker run --rm -p 8888:8080 -e NGINX_PORT=8080 -v ${PWD}/index.html:/usr/share/nginx/html/index.html -v ${PWD}/conf:/etc/nginx/templates nginx
  ```

## Transform two complex docker run into a docker-compose.yml

The goal of this exercise is to first run two dependent services using `docker run` and then transform it to a `docker-compose.yml` containing the definition of both services.

- Create a volume (it will be used by the database for persisting the data)
  ```bash
  docker volume create db_data
  ```
- Create a network (it will be use by both the database and Wordpress in order to see each other)
  ```bash
  docker network create wp-app-network
  ```
- Run a MySQL database with the required configuration:
  ```bash
  docker run -d -p 3306:3306 -p 33060:33060 --network wp-app-network --network-alias db -e MYSQL_HOST=mysql -e MYSQL_ROOT_PASSWORD=somewordpress -e MYSQL_DATABASE=wordpress -e MYSQL_USER=wordpress -e MYSQL_PASSWORD=wordpress -v db_data:/var/lib/mysql mysql:8.0.19
  ```
- Run a Wordpress server using the previous database
  ```bash
  docker run -d -p 80:80 --network wp-app-network -e NGINX_PORT=8080 -e WORDPRESS_DB_HOST=db -e WORDPRESS_DB_USER=wordpress -e WORDPRESS_DB_PASSWORD=wordpress -e WORDPRESS_DB_NAME=wordpress wordpress
  ```
- Access http://localhost:80 and check that it works.
- Now the fun part: transform the previous docker commands into a `docker-compose.yml` containing all the required configuration.
  - Hints:
    - Each container should be a separate service.
    - You don't need to create a network. Since they both are in the same xxxx

## Bonus track

- Check the existing networks: `docker network ls`
- Check the existing volumes: `docker volume ls`
  - Remark even if you didn't create them manually, it appears several volumes: they are automatically created for each docker-compose by default, so that their services can communicate.
- `docker-compose down -v`
- Change several things in the exercises and see its impact, e.g.:
  - Change the port numbers for the host
  - Change Python code

## Resources

- https://docs.docker.com/compose/gettingstarted/
