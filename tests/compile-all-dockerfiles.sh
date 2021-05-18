#!/bin/bash

set -e
set -x

dockerfiles=(
  "./exercise-4/nginx-flask-mongo/flask/Dockerfile"
  "./exercise-5/entrypoint-cmd/Dockerfile"
  "./exercise-6/1-caching/Dockerfile"
  "./exercise-6/2-multi-stage-builds/Dockerfile.1"
  "./exercise-6/2-multi-stage-builds/Dockerfile.2"
  "./exercise-6/2-multi-stage-builds/Dockerfile.3"
  "./exercise-7/Dockerfile"
  #"./exercise-9/my-nano-app/Dockerfile"
  "./solutions/exercise-5/Dockerfile"
  "./solutions/exercise-5/Dockerfile.1"
  "./solutions/exercise-5/Dockerfile.2"
  "./solutions/exercise-5/Dockerfile.3"
  "./solutions/exercise-5/Dockerfile.4"
  "./solutions/exercise-5/Dockerfile.5"
  "./solutions/exercise-5/Dockerfile.6"
  #"./solutions/exercise-6/part 1/Dockerfile"
  #"./solutions/exercise-6/part 3/Dockerfile.1"
  #"./solutions/exercise-6/part 3/Dockerfile.2"
  #"./solutions/exercise-6/part 3/Dockerfile.3"
  "./solutions/exercise-9/my-nano-app/Dockerfile"
)

basedir=`pwd`

for dockerfile in "${dockerfiles[@]}"; do
  cd $basedir
  cd "`dirname "$dockerfile"`"
  docker build -t docker-training-test-compile -f `basename "$dockerfile"` .
done
