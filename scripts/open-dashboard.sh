set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $SCRIPT_DIR/set-kubeconfig.sh

kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')

echo "=================================================================================================================="
echo "Copy the previous token in the clipboard and you will have to paste it in the login page that should be open next."
echo ""
read -p "Press enter to open the dashboard in your browser:" VAR

open http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

kubectl proxy
