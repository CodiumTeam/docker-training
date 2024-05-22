#!/bin/bash

set -e
set -x

dockerfiles=(
  "./exercise-04/nginx-flask-mongo/flask/Dockerfile"
  "./exercise-05/entrypoint-cmd/Dockerfile"
  "./exercise-06/1-caching/Dockerfile"
  "./exercise-06/2-multi-stage-builds-cpp/Dockerfile.1"
  "./exercise-06/2-multi-stage-builds-cpp/Dockerfile.2"
  "./exercise-06/2-multi-stage-builds-cpp/Dockerfile.3"
  "./exercise-06/4-multi-stage-builds-php/Dockerfile.1"
  "./exercise-06/4-multi-stage-builds-php/Dockerfile.2"
  "./exercise-07/project/Dockerfile"
  "./exercise-08/Dockerfile"
  #"./exercise-09/my-nano-app/Dockerfile"
  #"./exercise-09/my-node-app/Dockerfile"
  "./exercise-11/Dockerfile"
  "./exercise-12/1-python/flask/Dockerfile"
  "./exercise-12/2-angular/Dockerfile"
  "./solutions/exercise-05/Dockerfile"
  "./solutions/exercise-05/Dockerfile.1"
  "./solutions/exercise-05/Dockerfile.2"
  "./solutions/exercise-05/Dockerfile.3"
  "./solutions/exercise-05/Dockerfile.4"
  "./solutions/exercise-05/Dockerfile.5"
  "./solutions/exercise-05/Dockerfile.6"
  "./solutions/exercise-05/Dockerfile.angular.cli"
  #"./solutions/exercise-06/part 1/Dockerfile"
  #"./solutions/exercise-06/part 3/Dockerfile.1"
  #"./solutions/exercise-06/part 3/Dockerfile.2"
  #"./solutions/exercise-06/part 3/Dockerfile.3"
#  "./solutions/exercise-09/my-nano-app/Dockerfile"
#  "./solutions/exercise-09/my-node-app/Dockerfile"
#  "./solutions/exercise-11/part 2/Dockerfile"
)

basedir=`pwd`

for dockerfile in "${dockerfiles[@]}"; do
  cd $basedir
  cd "`dirname "$dockerfile"`"
  docker build -t docker-training-test-compile -f `basename "$dockerfile"` .
done

cd $basedir/exercise-12/jenkins/jenkins-runner && docker-compose build
