# Phase 2 — GitLab + Runner

## Prérequis
- VM `gitlab` avec Docker installé
- IP : `192.168.1.13`

## Déploiement

```bash
mkdir -p /opt/gitlab
nano /opt/gitlab/docker-compose.yml
```

```yaml
volumes:
  config:
    driver: local
  data:
    driver: local
  logs:
    driver: local
  runner:
    driver: local

services:
  gitlab:
    restart: unless-stopped
    image: gitlab/gitlab-ce:latest
    container_name: gitlab
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'http://192.168.1.13'
        gitlab_rails['gitlab_shell_ssh_port'] = 2222
    ports:
      - '80:80'
      - '2222:22'
    volumes:
      - 'data:/var/opt/gitlab'
      - 'config:/etc/gitlab'
      - 'logs:/var/log/gitlab'
  gitlab-runner:
    restart: unless-stopped
    image: gitlab/gitlab-runner
    container_name: gitlab-runner
    volumes:
      - '/var/run/docker.sock:/var/run/docker.sock'
      - 'runner:/etc/gitlab-runner'
      - 'config:/etc/gitlab'
```

```bash
docker compose up -d
```

GitLab est accessible quand `docker compose ps` affiche `healthy` (~5 min).

## Mot de passe root

```bash
docker exec gitlab cat /etc/gitlab/initial_root_password
```

## Enregistrer le Runner

Dans GitLab → Admin Area → CI/CD → Runners → New instance runner → copie le token.

```bash
docker compose exec gitlab-runner /bin/bash
gitlab-runner register --url http://192.168.1.13 --token <TOKEN>
```

Répondre :
- URL : Entrée (déjà renseignée)
- Name : `runnergitlab`
- Executor : `docker`
- Image : `alpine:latest`

## Vérifier

Runner **Online** visible dans Admin Area → CI/CD → Runners.