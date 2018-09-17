#!/bin/bash
# Script: Instalação do docker-engine versão 17.03.1.ce e adicionar usuário rancher para não pedir senha
## Validando se foi passada as variaveis no comando
echo "## Validando variaveis"
if [ -z "$1" ];
then
  echo "# A senha nao foi passada"
  exit 2
else
  echo "# Senha detectada"
fi
if [ -z "$2" ];
then
  echo "# URL do Rancher nao detectada"
  exit 2
else
  echo "# URL Detectada"
fi

## Adicionando usuário no sudoers
sudo chmod u+rw /etc/sudoers.d/waagent
echo $1 > /dev/null
sudo sed -i s/ALL\=\(ALL\)\ ALL/ALL\=\(ALL\)\ NOPASSWD\:\ ALL/g /etc/sudoers.d/waagent
echo $1 > /dev/null


## Subindo o rancher node
echo "# Installing Rancher Agent"
while [ $STATUS -gt 0 ]
do
  sleep $SLEEP
  OUTPUT=`sudo docker run -e "CATTLE_AGENT_IP=$LOCAL_IP" -d --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher rancher/agent:$AGENT_VERSION $HOST_URL 2>&1`
  STATUS=$?
  echo $OUTPUT
done

exit $STATUS
