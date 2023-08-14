
CLUSTERYAML=cluster.yaml

IP=${1:-NIETS}
KEYPATH=${2:-/home/ec2-user/.ssh/roha_account2.pem}
USER=${3:-ubuntu}

if [ $1 == "NIETS" ]
then
	echo "./2addworker.ksh IP-ADDRESS KEY-PATH2PEM[roha_account2] USER[ubuntu]"
	exit
fi

echo "  - ssh:
      address:  ${IP}
      user: ${USER}
      port: 22
      keyPath: ${KEYPATH} 
    role: worker
" >> $CLUSTERYAML

