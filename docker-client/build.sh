#!/bin/bash

FOLDER=$(dirname $0)
DOCKER_PUSH=$1

# Download dependencies
docker pull xataz/alpine:3.4

# Build docker-client
echo "Build with docker 1.12.5"
docker build --build-arg DOCKER_VER=1.12.5 -t xataz/docker-client:1.12.5 $FOLDER
docker tag xataz/docker-client:1.12.5 xataz/docker-client:1.12
docker tag xataz/docker-client:1.12.5 xataz/docker-client:latest


docker push xataz/docker-client:1.12.5
docker push xataz/docker-client:1.12
docker push xataz/docker-client:latest

