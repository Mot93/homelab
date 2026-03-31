# TODO

List of features and issues being worked on.

## In Progress

- [ ] Write an ansible playbook to install k3s
- [ ] Backup has to not backup the download folder of BitTorrent
- [ ] uptime-kuma
  - [x] kuma
  - [ ] [auto kuma](https://github.com/BigBoot/AutoKuma) for automatic monitoring
- [ ] Keycloak
  - [ ] Remove volumes created automatically, use local storage instead

## Todo

- [ ] Check if necessary variables are defined inside the global `.env` file
- [ ] Backup all docker compose volumes using `rsync`
  - `rsync` has to use the same variable `DOCKER_VOLUMES` as the compose.yaml` to automate sync
- [ ] Prometheus and Grafana for monitoring
- [ ] GitLab
- [ ] Ollama + Open WebUI
- [ ] All READMEs

## Evaluating

- [ ] Immich
- [ ] Wasm Cloud
