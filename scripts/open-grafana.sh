set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $SCRIPT_DIR/set-kubeconfig.sh

open http://127.0.0.1:3000

kubectl port-forward -n kube-system "$(kubectl get -n kube-system pod --selector=k8s-app=grafana -o jsonpath='{.items..metadata.name}')" 3000
