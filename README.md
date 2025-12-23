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
Options:
    - `-d` run `docker compose down` down instead of `docker compose up`
    - `-r` remove all the images required by the docker compose configurations
