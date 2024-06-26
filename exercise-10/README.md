# Exercise 10: Clean up the system

In these exercises we will see how to free space and check what specific Docker resources are using that space.

## 10.1 List Docker resources

You can list all the existing resources (containers, images, volumes, networks):

```console
$ docker container ls -a
$ docker ps -a
$ docker image ls
$ docker volume ls
$ docker network ls
```

### Show Docker disk usage

- You can check how much space are taking your Docker resources:
  ```bash
  docker system df
  ```
  The information shown under the column `RECLAIMABLE` is the space consumed by "unused" resources, so that would be recoverable in case you deleted unused resources.
- You could get more detailed information about the specific resources:
  ```bash
  docker system df -v
  ```

## 10.2 Delete resources

You can practise deleting types of resources generated by all the previous exercises. By default, you should only delete unused resources. In case you tried to delete a used resource, you would get an error message with the info about the container using it:

- Remove unused images
  ```bash
  docker image prune
  ```
- Remove all unused local volumes
  ```bash
  docker volume prune
  ```
- Remove all unused networks
  ```bash
  docker network prune
  ```
- If you just want to focus on the resources managed by a specific docker-compose, you can stop and remove all containers, networks, images and volumes like this:
  ```bash
  docker compose down --rmi all --volumes
  ```
  
<details>
<summary><b>Click to show possibly harmful commands</b></summary>

> **Warning!** these commands will delete stopped containers, if you have containers that you don't want to delete, don't try these.


- Remove all stopped containers
  ```bash
  docker container prune
  ```
- Remove all unused data (i.e. all unused containers, networks, images and optionally, volumes)
  ```bash
  docker system prune -a
  ```
</details>

## Resources

- https://docs.docker.com/engine/reference/commandline/system_df/
- https://docs.docker.com/engine/reference/commandline/container_prune/
- https://docs.docker.com/engine/reference/commandline/system_prune/
- https://docs.docker.com/engine/reference/commandline/image_prune/
- https://docs.docker.com/engine/reference/commandline/volume_prune/
- https://docs.docker.com/engine/reference/commandline/network_prune/
