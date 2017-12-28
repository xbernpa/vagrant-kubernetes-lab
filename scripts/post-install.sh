#!/bin/bash
echo "-------------------------------------------------------------------------------"
echo "----------------------------<<< POST-INSTALL >>>-------------------------------"
echo "-------------------------------------------------------------------------------"
set -e -x

NETWORK=$1
if [ -z "$NETWORK" ]; then
    NETWORK=weave
fi

if [ "$NETWORK" == "flannel" ]; then
    # Install Flannel 
    # Change kube-proxy options
    kubectl patch daemonset kube-proxy -n kube-system --type='json' -p='[{"op": "add", "path": "/spec/template/spec/containers/0/command/2", "value":"--proxy-mode=userspace"}]'
    kubectl create -f /vagrant/networking/kube-flannel.yml
else
    # Install Weave Net
    kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
fi

# Install heapster
kubectl apply -f /vagrant/monitoring/kube-heapster.yml

# Install dashboard
kubectl apply -f /vagrant/dashboard/admin-user.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

# install Helm server (tiller)
kubectl create serviceaccount -n kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account=tiller --tiller-namespace=kube-system
