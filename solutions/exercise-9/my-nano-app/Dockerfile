# base image
FROM debian:latest

# Official Debian and Ubuntu images automatically run apt-get clean, so explicit invocation is not required.
# https://docs.docker.com/develop/develop-images/dockerfile_best-practices/

# install basic apps
RUN apt-get update \
    && apt-get install -qy nano