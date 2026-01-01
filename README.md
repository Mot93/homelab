# Home Lab
This is a collection of all the installation in my homelab.

## General configurations
Some configurations are shared across application, all are stored in the `.env` file in the root directory.

Example:
```bash
# Base path where to store all the docker compose volumes
# also used by rsync to backup configurations and data
DOCKER_VOLUMES="path/to/volumes"
```

## Docker compose
Most application are managed using [`docker compose`](https://docs.docker.com/compose/).
To automate most processes the script `compose.sh` was created.
### Structure
Required `compose.yaml`:
    - Compose file with all the configurations
Optional `.env`:
    - File with sensistive data that will be loaded on the server
### How to use `compose.sh`
Launch `compose.sh` followed by a the name of a directory containing a `compose.yaml` file.

Example: `compose.sh pihole`

With flags: `compose.sh <env> -dr`

If a command (such as pull images) has to be executed to multiple specific compose, specify the name separated by a comma

Example: `compose.sh jellyfin,pihole -p`


If a command (such as pull images) has to be executed to all the compose use the keyword `all`

Example: `compose.sh all -p`

Options:
- `-d` run `docker compose down` down instead of `docker compose up`

    Example: `compose.sh pihole -d`
- `-e` remove all the images required by the docker compose configurations

    Example: `compose.sh pihole -e`
- `-r` restart all the containers defined in the docker compose

    Example: `compose.sh pihole -r`
- `-p` pull all the images defined in the compose

    Example: `compose.sh pihole -p`

## SSO
In order to avoid having one account for each user on each app, keycloak is deployed to manage SSO.
