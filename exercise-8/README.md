# Exercise 8: How to publish your own images

Here you will practice how to publish your own images in order to share them with other people. We will show several examples: using your own local registry, Docker Hub or the GitLab registry.

## 8.1 Publishing in your own Registry

In this exercise we are going to publish our own image into a Registry running in our local machine (this way you don't need to create any account externally).

1. Start a Docker container registry in your local machine (you need to be under `/exercise-8`, we have prepared a docker-compose file with the needed services for that)
   ```bash
   docker compose up -d
   ```
1. Access the Registry UI in [http://localhost:80](http://localhost:80), using `registry` as username and `ui` as password. You will see that there are no images.
1. Build your own image from the Dockerfile under `/exercise-8`:
   ```bash
   docker build -t my-alpine-cat .
   ```
1. Tag your image:
   ```bash
   docker image tag my-alpine-cat localhost/my-alpine-cat:v1
   ```
1. Push your image to the registry and see how it fails
   ```bash
   docker push localhost/my-alpine-cat:v1
   ```
1. You will see that the push failed with a message `no basic auth credentials`.

   You need to login with username `registry` and password `ui`
   ```bash
   docker login localhost
   ```
1. Now push again and see how it works
   ```bash
   docker push localhost/my-alpine-cat:v1
   ```
   If you access [http://localhost:80](http://localhost:80) you will see your image with the corresponding tag.
1. Notice that you have locally the built image `localhost/my-alpine-cat:v1`
   ```bash
   docker images
   ```
1. Now delete it and check that it disappeared from your local images
   ```bash
   docker rmi localhost/my-alpine-cat:v1
   ```
1. Pull the image from the Registry (this is what anyone would need to do in order to use it, either like that or in the `FROM` instruction of a Dockerfile):
   ```bash
   docker pull localhost/my-alpine-cat:v1
   ```
1. Check that the image was pulled from the registry
   ```bash
   docker images
   ```
1. If you want, you can logout from the registry
   ```bash
   docker logout localhost
   ```
1. Finally stop your registry and remove all data
   ```bash
   docker compose down
   ```

## 8.2 How to publish an image to a public repository

You can use a public repository in exactly the same as the private one. You will need to create an account, login, and push the image as seen above. The prefix of the image tag (previously `localhost`) is used by Docker to locate the registry. This is the only part the needs to change according to the registry you want to use. Docker Hub is the default and most common image repository. It also hosts the _official_ images. However, there are many others, like `quay.io`; GitLab also offers an image repository linked to each git repository. 
### Docker Hub
Most of the steps for this exercise are similar to the previous ones.

1. First, you need to create a Docker Hub account: https://hub.docker.com/signup/
1. Now, if you login without specifying a registry, it will use Docker Hub by default:
   ```bash
   docker login --username [your-docker-hub-username]
   ```
   There are several alternatives to introducing your credentials like that, but it's beyond the scope of these exercises.
1. Build an image as you did in the previous example
   ```bash
   docker build -t my-alpine-cat .
   ```
1. Tag your image:
   ```bash
   docker image tag my-alpine-cat [your-docker-hub-username]/my-alpine-cat:v1
   ```
1. The rest of the exercise would be the same as the previous one, just changing `localhost` with `[your-docker-hub-username]`
1. You should be able to see your images published under https://hub.docker.com/

### GitLab

Again, all the steps would be the same except the way to login, which might be something like:

```bash
docker login [your-gitlab-registry] -u [your-gitlab-user] -p [your-access-token-or-password]
```
where `[your-gitlab-registry]` could be something like `registry.gitlab.com`

You can create a Gitlab access token [here](https://gitlab.com/-/profile/personal_access_tokens).


You will need to tag the image like:
   ```bash
   docker image tag my-alpine-cat [your-gitlab-registry]/[your-gitlab-username]/[repository-name]:v1
   ```
and push it with:
   ```bash
   docker push [your-gitlab-registry]/[your-gitlab-username]/[repository-name]:v1
   ```

## More information

- https://docs.docker.com/registry/
- https://docs.docker.com/docker-hub/
- https://docs.gitlab.com/ee/user/packages/container_registry/
