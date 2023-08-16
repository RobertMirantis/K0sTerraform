TEMPLATEFILE=../templates/cluster_init.yaml
RESULT=cluster.yaml

rm -f ${RESULT}*

LBDNSNAME=${1:-THIS_NEEDS_THE_LOAD_BALANCER_DNS_NAME}
CLUSTERNAME=${2:-THIS_NEEDS_THE_CLUSTERNAME}

cat ${TEMPLATEFILE} | sed "s|LBNAME|${LBDNSNAME}|g" | sed "s|CLUSTERNAME|${CLUSTERNAME}|g" > $RESULT


which kubectl
if [ $? -ne 0 ]
then
   curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
   sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
fi
