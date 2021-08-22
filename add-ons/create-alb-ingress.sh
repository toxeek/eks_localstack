#!/usr/bin/env bash

if [[ ! $(which helm) ]]; then 
    echo "[+] make sure you install helm first, exiting." && exit 125
fi

helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm install alb-ingress-controller \
  --set autoDiscoverAwsRegion=true \
  --set autoDiscoverAwsVpcID=true \
  --set clusterName=staging-craftercms-eks-cluster \
  --set rbac.serviceAccountAnnotations."eks\.amazonaws\.com/role-arn=arn:aws:iam::$1:role/ALBIngressControllerIAMRole" \
  --namespace kube-system \
  incubator/aws-alb-ingress-controller