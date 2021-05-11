# Exercise 3: ports, volumes and environment variables

## Bind mount volume

- Run the next command. Verify how it fails and think why:
  ```bash
  docker run --rm alpine ls /codium
  ```
- Now run it mapping a volume:
  ```bash
  docker run --rm -v ${PWD}:/codium alpine ls /codium
  ```
  What happened here?

## TBD

- TBD
  ```bash
  docker run --rm -d -P nginx
  ```
- TBD
  ```bash
  docker ps
  ```
- TBD
  ```bash
  docker run --rm -d -p 8888:80 nginx
  ```
- TBD
  ```bash
  docker ps
  ```
- Finally, open http://localhost:8888 in the browser and check that it works

## TBD

```bash
cd ./exercise-3
docker run --rm -d -P -v ${PWD}/index.html:/usr/share/nginx/html/index.html nginx
```

Modify the index.html file in the host
Observe the changes in the image, since the file was not copied, it is mounted.

### Environment variables

```bash
docker run --rm postgres

docker run --rm -e POSTGRES_PASSWORD=b postgres

export POSTGRES_PASSWORD=b
docker run --rm -e POSTGRESS_PASSWORD postgres
```

```bash
cd ./exercise-3
docker run --rm -p 8888:8080 -e NGINX_PORT=8080 -v ${PWD}/index.html:/usr/share/nginx/html/index.html -v ${PWD}/conf:/etc/nginx/templates nginx
```

Verify the nginx server is up and running and showing our index.html on http://localhost:8888/

## Bonus track

### Understand the working directory

- From inside the folder `exercise-3`, try and run the next command:
  ```bash
  docker run -v ${PWD}:/home/codium python python hello.py
  ```
  What happened? Why didn't it work?
- Now run:
  ```bash
  docker run -v ${PWD}:/home/codium python python /hello.py
  ```
  Why did it work?
- Now let's run the python script from a specific folder:
  ```bash
  docker run -v ${PWD}:/home/codium -w /home/codium python python hello.py
  ```
  What is happening?

### Extra

If you have any Python script, you can try and run it with Docker. - Did it work? In case it didn't, why?
