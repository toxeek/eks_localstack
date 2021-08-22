#!/usr/bin/env bash

if [[ ! $(which helm) ]]; then 
    echo "[+] make sure you install helm first, exiting." && exit 125
fi

helm install external-dns \
  --set provider=aws \
  --set aws.zoneType=public \
  --set txtOwnerId=external-dns \
  --set domainFilters[0]=toxeeklabs.com \
  --set policy=sync \
  --set rbac.serviceAccountAnnotations."eks\.amazonaws\.com/role-arn=arn:aws:iam::$1:role/ExternalDnsIAMRole" \
  --namespace kube-system \
  stable/external-dns