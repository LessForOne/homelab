# Phase 1 — Infrastructure as Code (OpenTofu)

## Prérequis
- OpenTofu installé
- Accès à Xen Orchestra (`ws://192.168.1.5`)
- Template `base-debian12` disponible sur le SR NFS

## Structure

```
terraform/
├── versions.tf       # provider xenorchestra + version OpenTofu
├── variables.tf      # déclaration des variables
├── terraform.tfvars  # valeurs (gitignore)
└── main.tf           # data sources + ressources VMs
```

## Variables

| Variable | Description |
|---|---|
| `xo_url` | URL Xen Orchestra (ws://...) |
| `xo_user` | Username XO |
| `xo_pass` | Password XO |
| `vms` | Map des VMs à créer (ram, cpu, disk) |

## VMs provisionnées

| VM | CPU | RAM | Disk | IP |
|---|---|---|---|---|
| gitlab | 2 | 4GB | 40GB | 192.168.1.13 |
| k3s | 2 | 2GB | 30GB | 192.168.1.12 |
| minio | 1 | 1GB | 50GB | 192.168.1.14 |
| dev | 2 | 2GB | 30GB | 192.168.1.11 |

## Déploiement

```bash
# Initialiser le provider
tofu init

# Vérifier le plan
tofu plan

# Appliquer
tofu apply
```

## Post-apply

Sur chaque VM via console XO :

```bash
su -
hostnamectl set-hostname <nom-vm>
echo "127.0.1.1 <nom-vm>" >> /etc/hosts
systemctl restart networking
```

## Détruire l'infra

```bash
tofu destroy
```