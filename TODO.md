# TODO
List of features and issues being worked on.

## In Progress
- [ ] [nginx proxy manager](https://github.com/NginxProxyManager/nginx-proxy-manager)
- [ ] Keycloak
    - [ ] Remove volumes created automatically, use local storage instead 

## Todo
- [ ] Check if necessary variables are defined inside the global `.env` file
- [ ] Backup all docker compose volumes using `rsync`
    - `rsync` has to use the same variable `DOCKER_VOLUMES` as the ccompose.yaml` to automate sync
- [ ] Perplexica or equivalent
- [ ] uptime-kuma and [auto kuma](https://github.com/BigBoot/AutoKuma) for automatic monitoring
- [ ] Prometheus and Grafana for monitoring
- [ ] GitLab
- [ ] Ollama + Open WebUI
- [ ] All READMEs

## Evaluating
- [ ] Immich
- [ ] Wasm Cloud
