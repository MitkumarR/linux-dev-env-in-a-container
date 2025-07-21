#!/bin/bash

VOLUME_PATH=$(docker volume inspect apache-data -f '{{ .Mountpoint }}')

set -a
source .env
set +a

# Check if volume exists, if not create it
if ! docker volume inspect apache-data >/dev/null 2>&1; then
  echo "Creating volume 'apache-data'..."
  docker volume create apache-data
fi

sudo cp -r html/* "$VOLUME_PATH/"

echo "Stopping existing container (if running)..."
docker stop apache-ssh 2>/dev/null

echo "Removing existing container (if exists)..."
docker rm -f apache-ssh 2>/dev/null


echo "Running new container..."
docker run -d \
  -p 8080:80 \
  -p $SSH_PORT:22 \
  --name apache-ssh \
  -v apache-data:/var/www/html \
  my-apache-app


echo "Container 'apache-ssh' is now running on:"
echo "  - Web:    http://localhost:8080"
echo "  - SSH:    ssh $USERNAME@localhost -p $SSH_PORT"

