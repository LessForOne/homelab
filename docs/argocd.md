# Phase 4 — ArgoCD GitOps

## Prérequis
- k3s opérationnel
- GitLab avec repo `homelab-apps`

## Installation ArgoCD

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Attendre que tous les pods soient Running :

```bash
kubectl get pods -n argocd
```

## Exposer l'UI

```bash
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'
kubectl get svc argocd-server -n argocd
```

UI accessible sur `http://192.168.1.12:<NodePort>`

## Mot de passe admin

```bash
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
```

## Connecter le repo GitLab

Dans ArgoCD → Settings → Repositories → Connect Repo :

| Champ | Valeur |
|---|---|
| Method | HTTPS |
| URL | `http://192.168.1.13/root/homelab-apps.git` |
| Username | `root` |
| Password | token GitLab (`glpat-...`) |

Créer le token dans GitLab → Edit profile → Access Tokens → scope `read_repository`.

## Déployer une app via GitOps

Structure du repo `homelab-apps` :

```
homelab-apps/
└── n8n/
    ├── deployment.yaml
    ├── service.yaml
    └── pvc.yaml
```

Dans ArgoCD → Applications → New App :

| Champ | Valeur |
|---|---|
| Application Name | `n8n` |
| Project | `default` |
| Sync Policy | `Automatic` |
| Repository URL | `http://192.168.1.13/root/homelab-apps.git` |
| Path | `n8n` |
| Cluster | `https://kubernetes.default.svc` |
| Namespace | `default` |

Push les manifests dans Git → ArgoCD sync automatiquement → app déployée dans k3s.

## Vérifier

```bash
kubectl get pods -n default
kubectl get svc -n default
```

## Principe GitOps

- Tout changement passe par Git (pas de `kubectl apply` manuel)
- ArgoCD réconcilie en permanence le cluster avec l'état du repo
- Si quelqu'un modifie le cluster à la main, ArgoCD remet l'état conforme au repo