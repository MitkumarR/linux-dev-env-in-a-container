# Use the latest Ubuntu 22.04 LTS as base
FROM ubuntu:22.04

# Set build-time arguments (optional)
ARG USERNAME=docker-user

# Set default environment variables
ENV USERNAME=${USERNAME}
ENV SSH_PORT=${SSH_PORT}

# Update package repo and install Apache and SSH
RUN apt-get update && \
    apt-get install -y apache2 openssh-server && \
    rm -rf /var/lib/apt/lists/*

# Create user and set password
RUN useradd -m $USERNAME && \
    echo "$USERNAME:password" | chpasswd

# Install Supervisor
RUN apt update && apt install -y supervisor

# Create directory for supervisord config
RUN mkdir -p /var/log/supervisor

# Copy files from host
COPY html/ /var/www/html/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Give permissions
RUN chown -R $USERNAME:$USERNAME /var/www/html && \
    usermod -aG sudo $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Expose SSH and HTTP ports
EXPOSE 22 80

# Start services
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
