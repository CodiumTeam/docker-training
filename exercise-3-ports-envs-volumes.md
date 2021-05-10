# Exercise 3: ports, volumes and environment variables

The filesystem inside a container is ephemeral.

```bash
docker run -d --name long-running alpine sleep 1000
docker ps
docker exec long-running touch foobar
docker exec long-running ls foobar
docker stop long-running
docker start long-running
docker exec long-running ls foobar
docker kill long-running
docker run -d --name long-running alpine sleep 1000
docker exec long-running ls foobar
```

```bash
docker run --rm -d -P nginx
docker ps
```

Open localhost:xxxx in browser

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
docker run --rm -p 8888:8080 -e NGINX_PORT=8080 -v ${PWD}/conf:/etc/nginx/templates nginx
```

Verify the nginx server is up and running on http://localhost:8888/

## Working directory

- Ejemplo que había antes: `docker run -v ${PWD}:/home/vicomtech -w /home/vicomtech python python hello.py`
