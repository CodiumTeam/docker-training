# Exercise 10: Security

## 10.1 Using Docker scan

In this exercise you will use the `docker scan` functionality to get a report of the vulnerabilities found in an image.

1. In the terminal, open the `exercise-10` folder.
1. Execute the following:
    ```bash
    docker build -t flask-app:v1 .
    docker scan flask-app:v1 -f Dockerfile
    ```
    You should see a report with quite a few vulnerabilities. Notice how it also gives some recommendations. If you change the base image you could reduce the number of vulnerabilities.

1. Since the `Dockerfile` accepts a build argument `TAG` to change the image tag, execute the previous commands with a different image and notice the difference in vulnerabilities:
    ```bash
    docker build -t flask-app:v2 --build-arg TAG=3.7.11-slim-buster .
    docker scan flask-app:v2 -f Dockerfile
    ```
By using a smaller image the number of issues has been massively reduced. Try using another image `3.7-alpine3.14` and notice how the vulnerabilities are reduced even further. Why did `docker scan` not recommend this tag?
  ```bash
  docker build -t flask-app:v3 --build-arg TAG=3.7-alpine3.14 .
  docker scan flask-app:v3 -f Dockerfile
  ```

Notice the difference in size between all three versions of the same container.
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
