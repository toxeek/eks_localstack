#!/usr/bin/env bash

## creates an oidc provider for the eks cluster. 1st arg must be 
## the cluster name

if [[ ! $(which aws) ]]; then 
    echo "[+] make sure you install aws cli first, exiting." && exit 125
fi

aws eks --region $1 update-kubeconfig --name $2