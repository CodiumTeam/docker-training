# Exercise 9: troubleshooting

Try to practice these commands with any of the previous containers.

## Docker native tools

- Show low-level information on Docker objects
  ```bash
  docker inspect my-alpine-cat:v1
  ```
- Show low-level information on a Docker image
  ```bash
  docker image inspect my-alpine-cat:v1
  ```
- Display a live stream of container(s) resource usage statistics
  ```bash
  docker stats
  ```
- Display the running processes for the docker compose services
  ```bash
  docker-compose top
  ```
- Fetch the logs of a container
  ```bash
  docker logs [your-container-id-or-name]
  ```
- Eventually you might see a `running out of disk space` error message. You could run `docker system df` to check what resources are taking space.

### Getting inside the container

- Only for troubleshooting or exploratory reasons, sometimes it is convenient to get into the container:
  ```bash
  docker exec -ti [your-container-id-or-name] [command]
  ```
  , where the command could be something like `sh` or `bash` (it depends on what is available inside the container)
- In the context of a docker compose, you could run:
  ```bash
  docker-compose exec [your-service] [command]
  ```

## Using external tools

- Top-like interface for container metrics: [ctop](https://github.com/bcicen/ctop)
- A simple terminal UI for both docker and docker-compose: [lazydocker](https://github.com/jesseduffield/lazydocker)
- With both previous tools you can even execute a shell (if the image allows it)
- Some IDEs, like VS Code or IntelliJ, offer extensions that you can use to interact and inspect your Docker resources

## Resources

- https://docs.docker.com/compose/reference/top/
- https://docs.docker.com/engine/reference/commandline/inspect/
- https://docs.docker.com/engine/reference/commandline/stats/
- https://docs.docker.com/engine/reference/commandline/logs/
- https://docs.docker.com/compose/reference/top/
