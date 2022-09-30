#!/bin/bash

set -e
set -x

dockerfiles=(
  "./exercise-4/nginx-flask-mongo/flask/Dockerfile"
  "./exercise-5/entrypoint-cmd/Dockerfile"
  "./exercise-6/1-caching/Dockerfile"
  "./exercise-6/2-multi-stage-builds-cpp/Dockerfile.1"
  "./exercise-6/2-multi-stage-builds-cpp/Dockerfile.2"
  "./exercise-6/2-multi-stage-builds-cpp/Dockerfile.3"
  "./exercise-6/4-multi-stage-builds-php/Dockerfile.1"
  "./exercise-6/4-multi-stage-builds-php/Dockerfile.2"
  "./exercise-7/project/Dockerfile"
  "./exercise-8/Dockerfile"
  #"./exercise-9/my-nano-app/Dockerfile"
  #"./exercise-9/my-node-app/Dockerfile"
  "./exercise-11/Dockerfile"
  "./exercise-12/1-python/flask/Dockerfile"
  "./exercise-12/2-angular/Dockerfile"
  "./solutions/exercise-5/Dockerfile"
  "./solutions/exercise-5/Dockerfile.1"
  "./solutions/exercise-5/Dockerfile.2"
  "./solutions/exercise-5/Dockerfile.3"
  "./solutions/exercise-5/Dockerfile.4"
  "./solutions/exercise-5/Dockerfile.5"
  "./solutions/exercise-5/Dockerfile.6"
  "./solutions/exercise-5/Dockerfile.angular.cli"
  #"./solutions/exercise-6/part 1/Dockerfile"
  #"./solutions/exercise-6/part 3/Dockerfile.1"
  #"./solutions/exercise-6/part 3/Dockerfile.2"
  #"./solutions/exercise-6/part 3/Dockerfile.3"
#  "./solutions/exercise-9/my-nano-app/Dockerfile"
#  "./solutions/exercise-9/my-node-app/Dockerfile"
#  "./solutions/exercise-11/part 2/Dockerfile"
)

basedir=`pwd`

for dockerfile in "${dockerfiles[@]}"; do
  cd $basedir
  cd "`dirname "$dockerfile"`"
  docker build -t docker-training-test-compile -f `basename "$dockerfile"` .
done

cd $basedir/exercise-12/jenkins/jenkins-runner && docker-compose build
