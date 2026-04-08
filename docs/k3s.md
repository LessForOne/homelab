# Phase 3 — k3s

## Prérequis
- VM `k3s` — IP : `192.168.1.12`

## Installation

```bash
curl -sfL https://get.k3s.io | sh -
```

## Vérifier

```bash
kubectl get nodes
kubectl get pods -A
```

Node `Ready` + tous les pods `Running` = cluster opérationnel.

## Infos utiles

```bash
# Kubeconfig
cat /etc/rancher/k3s/k3s.yaml

# Logs k3s
journalctl -u k3s -f

# Restart k3s
systemctl restart k3s
```