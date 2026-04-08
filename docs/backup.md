# Phase 7 — Velero + MinIO

## Prérequis
- k3s opérationnel
- MinIO accessible sur `http://192.168.1.5:9000`
- Bucket `homelabbackup` créé dans MinIO

## Installation CLI Velero

```bash
curl -fsSL -o velero.tar.gz https://github.com/vmware-tanzu/velero/releases/download/v1.15.2/velero-v1.15.2-linux-amd64.tar.gz
tar -xvf velero.tar.gz
mv velero-v1.15.2-linux-amd64/velero /usr/local/bin/
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
```

## Credentials MinIO

```bash
cat << 'CREDS' > /tmp/credentials-velero
[default]
aws_access_key_id=<ACCESS_KEY>
aws_secret_access_key=<SECRET_KEY>
CREDS
```

## Installer Velero dans k3s

```bash
velero install \
  --provider aws \
  --plugins velero/velero-plugin-for-aws:v1.11.0 \
  --bucket homelabbackup \
  --secret-file /tmp/credentials-velero \
  --use-volume-snapshots=false \
  --backup-location-config region=minio,s3ForcePathStyle="true",s3Url=http://192.168.1.5:9000
```

## Vérifier

```bash
kubectl get pods -n velero
velero backup-location get
```

`Available` = Velero connecté à MinIO ✅

## Backup manuel

```bash
velero backup create test-backup --include-namespaces default
velero backup describe test-backup
```

## Backup automatique (tous les lundis à 2h)

```bash
velero schedule create weekly-backup \
  --schedule="0 2 * * 1" \
  --include-namespaces default
```

## Restore

```bash
velero restore create --from-backup test-backup
velero restore describe <restore-name>
```