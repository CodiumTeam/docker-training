# Exercise 11: Security

## 11.1 Using Docker scan

In this exercise you will use the `docker scan` functionality to get a report of the vulnerabilities found in an image.

1. In the terminal, open the `exercise-11` folder.
1. Execute the following:
    ```bash
    docker build -t flask-app:v1 .
    docker scan flask-app:v1 -f Dockerfile
    ```
    You should see a report with quite a few vulnerabilities. Notice how it also gives some recommendations. If you change the base image, you could reduce the number of vulnerabilities.

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

## 11.2 Creating a non-privileged user

In this exercise you will modify the `Dockerfile` to ensure it runs as a non-privileged user. 

> NOTE: Use the alpine base image, i.e. `--build-arg TAG=3.7-alpine3.14` when building the image.

Hints
- When using `alpine` a new user and group is created as follows:
  ```bash
    addgroup -g 5000 newuser
    adduser -G newuser -S -u 5000 -s /bin/sh newuser
  ```
- Make sure you create the user in the beginning of the `Dockerfile`, then you execute all the instructions as the new user.
- Change the working directory to the home of the new user `/home/newuser`


```bash
  docker build -t flask-app:user --build-arg TAG=3.7-alpine3.14 .
  docker run --rm -d -P --name flask_user flask-app:user
```

If you inspect the processes started by this container, you will notice they are no longer initiated by `root`:
```bash
  docker top flask_user
```

## Bonus track

### Change owner of copied files

By default, `COPY` instructions always assign owner with ID 0, which in the Linux world means `root`. If you inspect the files copied into the container, you will observe this.
```bash
  docker exec flask_user ls -l
```

If you want to change this behaviour you can add a flag to the `COPY` statements to set a new owner to the copied files, e.g.
```Dockerfile
COPY --chown=newuser:newuser requirements.txt .
```

Stop the container, re-build it and check the file permissions once more.

### Further reading

- [Why not run as root](https://medium.com/@mccode/processes-in-containers-should-not-run-as-root-2feae3f0df3b).
- [Going rootless with Docker and Containers](https://mohitgoyal.co/2021/04/14/going-rootless-with-docker-and-containers)

