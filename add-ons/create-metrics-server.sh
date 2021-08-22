#!/usr/bin/env bash

if [[ ! $(which helm) ]]; then 
    echo "[+] make sure you install helm first, exiting." && exit 125
fi

helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/metrics-server
