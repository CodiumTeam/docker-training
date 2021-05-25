# Exercise 4: Docker Compose exercises

## 4.1 How to use an existing docker compose

In this first exercise we will use a provided `docker-compose` to start and stop a collection of containers (services). In this case it is a python container that is exposed in an nginx server and talks to a mongo database. It is important to realise how you can compose complex applications using individual simple components, containers, which fulfill a single function.

1. Go to the folder `exercise-4` move into the folder `nginx-flask-mongo`
1. To start the application all we need to do is

```bash
docker-compose up
```

The application runs in the foreground, so we see the logs of all the different containers.

1. In a different terminal, check that three services are up and running:

```bash
docker ps
```

1. Ensure you are in the same folder where the `docker-compose` file is, and run

```bash
docker-compose ps
```

Notice how this only lists the containers defined in that docker-compose.

1. Access the URL [http://localhost:80](http://localhost:80) and check that it works (you should see _Hello from the MongoDB client!_).
1. Go back to the original terminal and press `Ctrl+C` to stop.
1. Usually it is preferable to start in detached mode:
   ```bash
   docker-compose up -d
   ```

1. You can still see the logs of the containers:
   ```bash
   docker-compose logs web
   ```

   You can also keep the logs open to follow future changes:
   ```bash
   docker-compose logs -f web
   ```

1. Many of the commands we explored in the earlier module also work here. For example you can do
   ```
   docker-compose exec mongo mongo --eval "db.users.insertOne({name: 'jonas'})"
   ```

1. To remove everything use the `docker-compose down` command.

## 4.2 Create your own docker-compose.yml to run two docker services

The goal of this exercise is to define a `docker-compose.yml` that would allow us to run a copy of wordpress using mysql database to persist the data.

### Add wordpress service

1. In a new folder, let's start by creating a `docker-compose.yml` file which defines a single service for wordpress. You can use the official image `wordpress:5.7.1-apache`. By default this image runs wordpress in port 80; expose it to a local port in your machine so you can browse to it with your own browser.

2. You can verify the syntax of your docker-compose by running `docker-compose config`. If all is well, it should output a copy of your docker-compose.
3. You can then use `docker-compose up -d` to start up the service. You should be able to open wordpress in your browser.

### Add database service

1. Next add another service named `db` to run MySQL - again, use the official image `mysql:8.0.19`. You don't need to expose any ports in this case.
2. Execute again `docker-compose up -d` to start up this new service. Notice that as you have not modified the wordpress service, it has not been recreated.
3. Check the state of MySQL by executing `docker-compose ps`. You will see that the `db` service has exited. In order to find out why, execute `docker-compose logs db`. You should see that MySQL tried to start up but it requires some environment variables defining some initial configuration like the Admin password. Add the following variable to the docker compose:

- MYSQL_ROOT_PASSWORD=someDifficultPassword

4. Try to bring the service back up again.
5. Inspect the logs and verify that mysql is running successfully

### Link the two services

1. Lets define a user and an initial database for wordpress. You do this by creating extra environment variables in the `db` service:

- MYSQL_DATABASE=wordpress_db
- MYSQL_USER=wordpress_user
- MYSQL_PASSWORD=wordpress_password

2. You need to configure wordpress to leverage the `db` service to persist information. This is done by defining the following variables which tell wordpress how to connect to the database:

- WORDPRESS_DB_HOST=db
- WORDPRESS_DB_USER=wordpress_user
- WORDPRESS_DB_PASSWORD=wordpress_password
- WORDPRESS_DB_NAME=wordpress_db
- WORDPRESS_TABLE_PREFIX=wp_

  > Notice how we use the name of the database service as defined in the docker-compose file to indicate the host name of the database to the wordpress service. Services in docker-compose can reach each other using the service name as hostname for the destination, this is called DNS service discovery, it will only work for services using the same network, if no network is defined, docker-compose will create a default one and connect all services to it. 

3. Finally, you should add `depends_on` as an extra key to the `wordpress` service to express the dependency, since `wordpress` now requires the `db` service to function correctly.
4. Invoke `docker-compose up -d` again.
5. Execute `docker-compose logs -f db` to check the database is starting correctly with the new configuration. This process can take a few seconds.
6. Verify that the site is still displaying correctly in your browser.

If you get the error `Error establishing a database connection` it can be due two reasons:
 * The database is still starting, check for the message `ready for connections` in the logs, if the database is ready and the problem persists go to the next point.
 * Try running `docker-compose down` and bring it up again. This happens because you tried to set up a database connection from the web interface in the previous step and the docker container for wordpress created a config file with wrong credentials.
   When you brought up the database, the wordpress container was not recreated because its definition did not change, but we need it to start from a clean state, that's why we want to delete it and start a new one.


### Add persistence to avoid losing data

If you run `docker-compose down` and `up` again, the data would be lost. In order to keep it, you would need to define a volume to persist the data.

1. Declare a new volume at the end of the `docker-compose.yml`
   ```yaml
   version: "3.7"
   services:
      ...
   volumes:
     db_data:
   ```

2. Use the declared volume in the service where you need it
   ```yaml
   services:
     db:
       ...
       volumes:
         - db_data:/var/lib/mysql
   ```
3. Restart the application with `docker-compose up -d`
4. This volume will not be removed when doing `docker-compose down` hence your application data is persisted. If you wish to delete it you can run `docker-compose down -v`.

## Bonus track

- Check the existing networks: `docker network ls`
  - Notice that although you didn't create them manually, several networks are shown: they are automatically created for each docker-compose by default, so that their services can communicate.
- Check the existing volumes: `docker volume ls`

### Create your own docker-compose.yml to run a single service

- The goal of this exercise is to convert the `docker run` for nginx that we used in the [exercise-3](../exercise-3#33-combining-volumes-and-ports) to a simple docker-compose.
> We usually use docker-compose.yml for defining applications with 2 or more services (not just one like this example). This exercise with a single service docker-compose.yml is intended for pedagogical goals. However, even for a single service, the clearer syntax of the docker-compose.yml can be beneficial. Another advantage is that the file could be committed to source control.
- Please, transform the next docker run into a docker-compose.yml and verify that it works as expected:
  ```console
  $ cd nginx
  $ docker run --rm -p 8888:8080 -e NGINX_PORT=8080 -v ${PWD}/index.html:/usr/share/nginx/html/index.html -v ${PWD}/conf:/etc/nginx/templates nginx
  ```

### Example of the exercise without docker-compose

As seen above, docker-compose allows to start multiple containers in a very easy fashion. However the same functionality could be achieved using independent Docker commands. As an example, you could run Wordpress and MySQL doing the following:

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
  docker run -d -p 80:80 --network wp-app-network -e NGINX_PORT=8080 -e WORDPRESS_DB_HOST=db -e WORDPRESS_DB_USER=wordpress -e WORDPRESS_DB_PASSWORD=wordpress wordpress:5.7.1-apache
  ```
- Access [http://localhost:80](http://localhost:80) and check that it works.
- As you have just experienced, using Docker Compose is much easier and provides a much better experience.

## Resources

- https://docs.docker.com/compose/gettingstarted/
