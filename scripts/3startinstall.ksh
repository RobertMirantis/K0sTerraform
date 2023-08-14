
CLUSTERYAML=cluster.yaml

k0sctl apply --config $CLUSTERYAML

k0sctl kubeconfig --config cluster.yaml > ../kube.config

echo "Please find the KubeConfig file in kube.config"

MYDIR=`pwd`
export KUBECONFIG=$MYDIR/../kube.config

kubectl get nodes
