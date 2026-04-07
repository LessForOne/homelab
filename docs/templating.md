# Phase 0 — Base template

## Prérequis
- XCP-ng + SR NFS (`NFS-SR-DEBIAN`)
- Xen Orchestra
- ISO Debian 13 disponible dans XO

## Créer la VM

Dans XO → New VM :

| Paramètre | Valeur |
|---|---|
| Template | Other install media |
| ISO | debian-13.x.x-amd64-netinst.iso |
| Name | base-debian12 |
| CPU | 2 |
| RAM | 2 GB |
| Disk | 20 GB |
| SR | NFS-SR-DEBIAN |
| Network | Pool-wide network associated with eth0 |

Install Debian : pas de GUI, cocher `SSH server` + `standard system utilities`, créer user `user` avec sudo.

## Post-install

```bash
su -
apt update && apt install -y sudo openssh-server curl wget git
usermod -aG sudo user
```

## SSH sans mot de passe

```powershell
type $env:USERPROFILE\.ssh\id_ed25519.pub | ssh user@<IP> "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

## Convertir en template

```bash
# Éteindre
sudo shutdown -h now

# Sur l'hôte XCP-ng
xe vm-param-set uuid=<VM_UUID> is-a-template=true
```

## Cloner une VM

```bash
xe vm-clone uuid=<TEMPLATE_UUID> new-name-label="<nom>"
xe vm-param-set uuid=<CLONE_UUID> is-a-template=false
xe vm-start uuid=<CLONE_UUID>
```

## Post-clone

```bash
su -
hostnamectl set-hostname <hostname>
echo "127.0.1.1 <hostname>" >> /etc/hosts
systemctl restart networking
```

## UUIDs

| Ressource | UUID |
|---|---|
| Template `base-debian12` | `09e80ef1-7509-f7e6-6f3d-7217a97a76d9` |
| SR NFS | `e82743cc-e507-e5fd-2ea3-5bc6c8ce8a52` |