# Exercise 11: Pipelines
cp solutions/exercise-6/part\ 3/Dockerfile.2 exercise-6/3-sample-angular-app/Dockerfile
cd exercise-6/3-sample-angular-app

DOCKER_BUILDKIT=1 docker build -t registry.local/my-angular:${GIT_COMMIT} -t registry.local/my-angular:latest .

docker login registry.local -u $DOCKER_REGISTRY_USER -p $DOCKER_REGISTRY_PASSWORD
docker push registry.local/my-angular:${GIT_COMMIT}
docker push registry.local/my-angular:latest



```bash
cp solutions/exercise-6/part\ 3/Dockerfile.2 exercise-6/3-sample-angular-app/Dockerfile
cd exercise-6/3-sample-angular-app

DOCKER_BUILDKIT=1 docker build -t registry.local/my-angular:${GIT_COMMIT} -t registry.local/my-angular:latest .

docker login registry.local -u $DOCKER_REGISTRY_USER -p $DOCKER_REGISTRY_PASSWORD
docker push registry.local/my-angular:${GIT_COMMIT}
docker push registry.local/my-angular:latest

```