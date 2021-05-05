## Exercise N: Clean up the system

- `docker container prune`
- `docker image prune`
- `docker volume prune`
- `docker network prune`
- `docker system prune -a`

- Stop and remove all containers, networks, images, and volumes:
  docker-compose down --rmi all --volumes
