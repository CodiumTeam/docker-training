# Exercise 3: ports, volumes and environment variables

```bash
docker run --rm alpine ls /codium
docker run --rm -v ${PWD}:/codium alpine ls /codium
```

```bash
docker run --rm -d -P nginx
docker ps

docker run --rm -d -p 8888:80 nginx
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
docker run --rm -p 8888:8080 -e NGINX_PORT=8080 -v ${PWD}/index.html:/usr/share/nginx/html/index.html -v ${PWD}/conf:/etc/nginx/templates nginx
```

Verify the nginx server is up and running and showing our index.html on http://localhost:8888/

## Bonus track

- Ejemplo que había antes: `docker run -v ${PWD}:/home/codium -w /home/codium python python hello.py`

docker run -v ${PWD}:/home/codium python python /hello.py

si tienen un script suyo con Python, que prueben a ejecutarlo con un contenedor de Python
TODO: pensar en algún bonus track adicional
