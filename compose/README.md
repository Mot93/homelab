# Compose

Using [docker compose](https://docs.docker.com/compose/) to manage installations.

## General configurations

Some configurations are shared across application, all are stored in the `config.env` file in the root directory.

Example:

```bash
# Base path where to store all the docker compose volumes
# also used by rsync to backup configurations and data
DOCKER_VOLUMES="path/to/volumes"
```

Some configurations are to be hidden and not tracked by git in the configuration file `hidden.env`.

Example:

```bash
# For easier management of an enviroment where only some of the applications are installed.
INSTALLED="app1,app2"
```

## Task

You can use [task](https://github.com/go-task/task) as a wrapper.

To get the list of all the commands:

```bash
task --list
```

## Docker compose

Most application are managed using [docker compose](https://docs.docker.com/compose/).
To automate repetitive tasks, the script `compose.sh` was created.

### Structure

Each environment is a folder containing one or multiple files.

Required files:

- `compose.yaml` docker compose file with all the configurations necessary to a services to work a intended.

Optional files:

- `.env` file not tracked by git containing sensistive data that will be loaded together with the `compose.yaml`.

    All the configuration that can be tracked must be in the `compose.yaml` file.

### How to use `compose.sh`

Launch `./compose.sh` followed by a the name of a directory containing a `compose.yaml` file.

Example:

```bash
./compose.sh pihole
```

With flags:

```bash
compose.sh <env> -de
```

If a command (such as pull images) has to be executed to multiple specific compose, specify the name of each environment separated by a comma

Example:

```bash
compose.sh jellyfin,pihole -p
```

If a command (such as pull images) has to be executed to all the compose use the keyword `all`

Example:

```bash
compose.sh all -p
```

Available options:

- `-d` run `docker compose down` down instead of `docker compose up`

    Example:

    ```bash
    ./compose.sh pihole -d
    ```

- `-e` remove all the images required by the docker compose configurations. Must be used together with `-d`

    Example:

    ```bash
    compose.sh pihole -de
    ```

- `-r` restart all the containers defined in the docker compose

    Example:

    ```bash
    compose.sh pihole -r
    ```

- `-p` pull all the images defined in the compose

    Example:

    ```bash
    compose.sh pihole -p
    ```

## Backup

To backup the infrastructure:

```bash
backup.sh
```

Restore a backup:

```bash
backup.sh -r <backup name>
```

## SSO

In order to avoid having one account for each user on each app, keycloak is deployed to manage SSO.
