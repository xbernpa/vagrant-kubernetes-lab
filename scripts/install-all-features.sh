#!/bin/bash
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $SCRIPT_DIR/set-kubeconfig.sh

# Storage
set +x
echo "----------------------------<<< ADD STORAGE >>>-------------------------------"
set -x
kubectl apply -f storage/kube-nfsprovisioner.yml
kubectl patch storageclass example-nfs -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

# Ingress
set +x
echo "----------------------------<<< ADD INGRESS >>>-------------------------------"
set -x
kubectl create -f ingress/kube-nginx-ingress-controller.yml

# Monitoring
set +x
echo "----------------------------<<< ADD MONITORING >>>-------------------------------"
set -x
kubectl create -f monitoring/kube-influxdb-grafana.yml
kubectl apply --namespace kube-system -f "https://cloud.weave.works/k8s/scope.yaml?k8s-version=$(kubectl version | base64 | tr -d '\n')"
