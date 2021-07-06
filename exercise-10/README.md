# Exercise 10: security

## 10.1 Using Docker scan

LOGIN? 

```bash
docker build -t flask-app:v1 .
docker scan flask-app:v1 -f Dockerfile
```

```bash
docker build -t flask-app:v2 --build-arg TAG=3.7.11-slim-buster .
docker scan flask-app:v2 -f Dockerfile
```

```bash
docker build -t flask-app:v3 --build-arg TAG=3.7-alpine3.14 .
docker scan flask-app:v3 -f Dockerfile
```

```bash
docker images flask-app
```

## 10.2 Explore risks of priviledged users
[Why not run as root](https://medium.com/@mccode/processes-in-containers-should-not-run-as-root-2feae3f0df3b)

## 10.3 Creating a non-privileged user

```Dockerfile
RUN addgroup -g 5000 newuser \
  && adduser -G newuser -S \
    -u 5000 -s /bin/sh newuser

USER newuser
```

```bash
  docker build -t flask-app:user --build-arg TAG=3.7-alpine3.14 .
  docker run --rm -d -P --name flask_user flask-app:user

  docker top flask_user
  docker exec flask_user ls -l
  docker rm -f flask_user
```

```Dockerfile
COPY --chown=newuser:newuser requirements.txt .
```
