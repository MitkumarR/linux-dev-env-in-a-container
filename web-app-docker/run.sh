#!/bin/bash

# Load .env
set -a
source .env
set +a

# Get Docker volume path
VOLUME_PATH=$(docker volume inspect apache-data -f '{{ .Mountpoint }}')

# Create volume if not exists
if ! docker volume inspect apache-data >/dev/null 2>&1; then
  echo "Creating volume 'apache-data'..."
  docker volume create apache-data
fi

# Copy website files to volume
sudo cp -r html/* "$VOLUME_PATH/"

# Stop & remove previous container if exists
echo "Stopping and removing existing container (if any)..."
docker stop apache-ssh 2>/dev/null
docker rm -f apache-ssh 2>/dev/null

# Run new container
echo "Running new container..."
docker run -d \
  -p 8080:80 \
  -p $SSH_PORT:22 \
  --name apache-ssh \
  -v apache-data:/var/www/html \
  apache-app

# Wait a second for container to boot
sleep 1

# Copy SSH public key into container's authorized_keys
echo "Copying SSH public key into container..."
docker exec apache-ssh mkdir -p /home/$USERNAME/.ssh
docker cp ~/.ssh/id_rsa.pub apache-ssh:/home/$USERNAME/.ssh/authorized_keys
docker exec apache-ssh chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
docker exec apache-ssh chmod 700 /home/$USERNAME/.ssh
docker exec apache-ssh chmod 600 /home/$USERNAME/.ssh/authorized_keys

# Restart SSH service inside container
docker exec apache-ssh service ssh restart

# Final info
echo "Container 'apache-ssh' is now running:"
echo "  - Web:  http://localhost:8080"
echo "  - SSH:  ssh -i ~/.ssh/id_rsa $USERNAME@localhost -p $SSH_PORT"