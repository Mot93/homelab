# Home Lab
This is a collection of all the installation in my homelab.

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

Options:
- `-d` run `docker compose down` down instead of `docker compose up`

    Example: `compose.sh pihole -d`
- `-e` remove all the images required by the docker compose configurations

    Example: `compose.sh pihole -e`
- `-r` restart all the containers defined in the docker compose

    Example: `compose.sh pihole -r`
- `-p` pull all the images defined in the compose

    Example: `compose.sh pihole -p`