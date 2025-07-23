# Linux Dev environment in a Container

L-DEV(Linux Dev Environment in a Container) is a dokerized linux environment with ssha and apache access, containerizing a web server with a custom user, file permissions, and service isolation.

### Features
- Isolated Apache and SSH service in docker container
- Persistent web data stored in Docker volume
- SSH Hardening using public/private key authentication
- Remote shell access via openSSH

### Usage

1. Install Docker engine on your system: [install-docjer-engine.bash](https://github.com/MitkumarR/linux-dev-env-in-a-container/blob/main/install-docker-engine.bash)

2. Clone repository
    ```bash
    git clone https://github.com/MitkumarR/linux-dev-env-in-a-container.git
    ```

3. Generate an SSH key on the host machine
    ```bash
    ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
    ```
    You should see, asking for a file (press Enter to use default: ```~/.ssh/id_rsa```)

    You can keep passphrase for extra security.

4. Create docker image
    ```bash 
    docker build -t apache-app .
    ```

5. Run:
    ```bash
    cd web-app-docker/
    ./run.sh
    ```

6. Access your container

    - Web page: http://localhost:8080

    - SSH:

        ```bash
            ssh -i ~/.ssh/id_rsa $USERNAME@localhost -p $SSH_PORT
        ```

### Customization
1. Create .env file and can configure USERNAME, SSH_PORT, VOLUME_NAME
2. You can use different ssh algorithm and store secure. 
3. Instead of basic web page, you can run your own apache application, or any flask-app in this containerized linux dev environment

### File structure

```bash
project/
├── Dockerfile                # Main Dockerfile
├── run.sh                   # Script to build and run container
├── supervisord.conf         # To manage Apache and SSH services
├── html/                    # Default Apache web content
│   └── index.html
└── .env                     # Configurable environment variables (not committed)
```

### Connect
You’re welcome to fork, improve, or suggest changes.

If you find mistakes, unclear parts, or have better ideas — feel free to open an issue or pull request.

Feedback and contributions are appreciated.

Email: mitkumar1977@gmail.com

### Authors
Mit

### License
MIT