# Exercise 3: ports, volumes and environment variables

## 3.1 Bind mount volume

Run the following command. It should fail. Why?
  ```bash
  docker run --rm alpine ls /codium
  ```

Be default the `alpine` does not have a `/codium` folder.

Now run it mapping a volume:
```bash
docker run --rm -v ${PWD}:/codium alpine ls /codium
```
> If you are using Windows DOS shell use `%cd%` instead of `${PWD}` i.e. `docker run --rm -v %cd%:/codium alpine ls /codium`

Why is this working?

You have mapped a folder from the local computer into the `/codium` folder inside the container. As it is a bind mount volume, any changes to your local files are immediately available inside the container (like a soft link). Notice you need to specify an absolute path, hence why we are using the `$PWD` variable.

## 3.2 Exposing network ports

By default a container is isolated, it cannot be accessed from the outside (inbound), even though it has outbound network access.

As an example let's start a container running [NGINX](https://www.nginx.com/) the popular web server.

1. Start the container in dettached mode. Notice the `-P` parameter, this will allow inbound access to the container
  ```bash
  docker run --rm -d -P --name my-server nginx
  ```
1. The `-P` option automatically allocated a local port to access the container. In order to see the port number you can run `docker ps` and it will be displayed under the `PORTS` column.
1. Try accessing this localhost port in your browser.
1. Stop the container.
1. Alternatively you can define your own port
  ```bash
  docker run --rm -d -p 8888:80 --name my-server nginx
  ```
1. Open http://localhost:8888 in the browser and check that it works
1. Remove the container

## 3.3 Combining volumes and ports
Running an `nginx` server is useful, but ideally you want to serve your own HTML file. One way to do this would be to use a bind volume as shown earlier:

```bash
cd ./exercise-3
docker run --rm -d -p 8888:80 -v ${PWD}/index.html:/usr/share/nginx/html/index.html nginx
```
> Remember under Windows DOS you need to use `%cd%` instead of `${PWD}`
1. Navigate to [http://localhost:8888](http://localhost:8888) and see the content of the `index.html` file.
1. Modify the index.html file in the host
1. Refresh the browser and observe the changes. 

## 3.4 Environment variables
Very often you need to configure the behaviour of the executable program running inside the container. The most widely used way to do this is injecting environment variables which then the executable reads.

As an example, let's see use a `postgres` container.

1. Run a container with the `postgres` image
   ```bash
   docker run --rm postgres
   ```

1. Notice how the container fails because it requires setting the Admin password. In the `postgres` image you can specify this password via the `POSTGRES_PASSWORD` variable.

1. Run the container again but specifying a password (remember you can use CTRL+C to stop the container as we have not started it in dettached mode)
   ```bash
   docker run --rm -e POSTGRES_PASSWORD=b postgres
   ``` 

1. In many instances instead of defining the value of the variable you may want to use the value of the same variable as defined in the local computer:
   ```bash
   # bash (Linux/Mac/Unix)
   export POSTGRES_PASSWORD=b
   ```
   ```cmd
   REM Windows DOS shell
   SET POSTGRES_PASSWORD=b
   ```
   ```powershell
   # Windows Powershell
   $Env:POSTGRES_PASSWORD='b'
   ```
   ```bash
   docker run --rm -e POSTGRES_PASSWORD postgres
   ```

## Bonus track
### Combining it all together

In other cases you can also mount files to modify the configuration. In the following example we use a configuration file to modify the default port of NGINX. In this particular case this configuration file is also referring to an environment variable we are passing through the `docker run` command:

```bash
cd ./exercise-3
docker run --rm -p 8888:8080 -e NGINX_PORT=8080 -v ${PWD}/index.html:/usr/share/nginx/html/index.html -v ${PWD}/conf:/etc/nginx/templates nginx
```

Verify the nginx server is up and running and showing our index.html on http://localhost:8888/

As you can see the `docker run` command is getting quite verbose. In the next module we will see how it can be simplified using `docker-compose`.

### Understand the working directory

- From inside the folder `exercise-3`, try and run the next command:
  ```bash
  docker run -v ${PWD}:/home/codium python:alpine python hello.py
  ```
  What happened? Why didn't it work?

- Now run:
  ```bash
  docker run -v ${PWD}:/home/codium python:alpine python /home/codium/hello.py
  ```
  Why did it work?
  
- Now let's run the python script from a specific folder:
  ```bash
  docker run -v ${PWD}:/home/codium -w /home/codium python:alpine python hello.py
  ```
  What is happening?

### Extra

If you have any Python script, you can try and run it with Docker. - Did it work? In case it didn't, why?
