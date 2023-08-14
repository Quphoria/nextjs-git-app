# nextjs-git-app

This is a simple docker image for creating a nextjs container from a git repo, with support for SSH key authentication for cloning private repositories.  

A script is supplied for generating a new SSH Key.
Usage:  
```sh
./generate-git-ssh-key.sh KEY_COMMENT
```

`KEY_COMMENT` needs to be the repo git url, e.g. `git@github.com:Quphoria/nextjs-git-app.git`  

This will generate 2 files:
- `id_git`: This is the private key that needs to get mounted to `/id_git` inside the container
- `id_git.pub`: This is the public key that needs to get added to the deploy keys for the repository

Example `docker-compose.yml`:  
```yml
version: '3'

services:
  nextjs_app:
    container_name: nextjs_app
    image: quphoria/nextjs-git-app
    volumes:
      - ./id_git:/id_git
      - ./app:/app
    environment:
      - REPO_URL=[YOUR REPO URL]
      - REPO_EMAIL=[KEY_COMMENT]
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "1"
    restart: unless-stopped
```

The container supports a healthcheck script (`healthcheck.sh`) at the root of the repository (`/app`), where a non-zero exit code signals an unhealthy container  

