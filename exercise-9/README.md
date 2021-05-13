# Exercise 9: troubleshooting

Try to practise these commands with any of the previous containers.

## Docker built-in tools

- Show low-level information on any Docker object
  ```bash
  docker inspect my-alpine-cat:v1
  ```
- Show low-level information for a specific object type. This is useful when there is more than one resource with the same name. E.g. for volumes:
  ```bash
  docker volume inspect db_data
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

## Common errors

- `running out of disk space`
  - You could run `docker system df` to check what resources are taking space.
- `failed: port is already allocated`
  - This would happen when trying to run a container in a port already in use. Either use another port or you can find out what process is using it in order to free it.
- `If you intended to pass a host directory, use absolute path`
  - You would get that error message when trying to mount a volume using a relative path, e.g. `docker run --rm -d -v ./FOOBAR:/foobar nginx`
  - You need to use an absolute path, e.g. `docker run --rm -d -v ${PWD}/FOOBAR:/foobar nginx`

## Resources

- https://www.digitalocean.com/community/tutorials/how-to-debug-and-fix-common-docker-issues
- https://docs.docker.com/compose/reference/top/
- https://docs.docker.com/engine/reference/commandline/inspect/
- https://docs.docker.com/engine/reference/commandline/stats/
- https://docs.docker.com/engine/reference/commandline/logs/
- https://docs.docker.com/compose/reference/top/