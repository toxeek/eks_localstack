#!/usr/bin/env bash

## creates an oidc provider for the eks cluster. 1st arg must be 
## the cluster name

if [[ ! $(which eksctl) ]]; then 
    echo "[+] make sure you install eksctl first, exiting." && exit 125
fi

eksctl utils associate-iam-oidc-provider --cluster $1 --approve