#!/usr/bin/env bash

if [[ ! $(which kubectl) ]]; then 
    echo "[+] make sure you install kubectl first, exiting." && exit 125
fi

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.5/aio/deploy/recommended.yaml