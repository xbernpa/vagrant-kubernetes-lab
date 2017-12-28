set -e
if [[ -d "./kubeconfig" && -z "$KUBECONFIG" ]]; then
    echo "KUBECONFIG was defined using the generated kubeconfig in ./kubeconfig folder"
    export KUBECONFIG=`pwd`/kubeconfig/admin.conf
fi
