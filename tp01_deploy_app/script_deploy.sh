#!/bin/bash

set -e 
set -u 

# Alias server_jenkins
# Variable de mise en forme
RED='\033[0;31m'	# Red Color
YELLOW='\033[0;33m'	# Yellow Color
GREEN='\033[0;32m'	# Grean Color
NC='\033[0m' 		# No Color

#variable
group_name="tp1-arnaud-rg"
location="eastus"
group_test=$(az group exists --name $group_name)
group_vnet="tp1arnaudvnet"
group_subnet="tp1arnaudsubnet"
vm_name="tp1arnaudvm"
vm_image="UbuntuLTS"
vm_root="azureuser"
vm_type="Standard_DS1_v2"

#création du groupe de ressource az cli tp1-$myname

if $group_test == true; then
    echo "$(date +'%Y-%m-%d %H:%M:%S') [ INFO  ] : Le groupe existe déjà ..."

else
echo "$(date +'%Y-%m-%d %H:%M:%S') [ INFO  ] : Création du groupe de ressource ..."
az group create -l $location -n $group_name
az network vnet create \
    --resource-group $group_name \
    --name $group_vnet \
    --address-prefix 10.80.0.0/16 \
    --subnet-name $group_subnet \
    --subnet-prefix 10.80.1.0/24
fi



#creation d'une VM windows linux avec nodeje et nginx
echo "$(date +'%Y-%m-%d %H:%M:%S') [ INFO  ] : Creation de la vm ..."
az vm create \
    --resource-group $group_name \
    --name $vm_name \
    --image $vm_image \
    --admin-username $vm_root \
    --generate-ssh-keys \
    --size $vm_type \
    --custom-data cloud-init.txt

#Ouverture port 80 vm
echo "$(date +'%Y-%m-%d %H:%M:%S') [ INFO  ] : Ouverture du port 80 ..."
az vm open-port --port 80 --resource-group $group_name --name $vm_name --priority 100

#Lister les adresse ip de la machine
echo "$(date +'%Y-%m-%d %H:%M:%S') [ INFO  ] : Adresses ip : "
az vm list-ip-addresses -g $group_name -n $vm_name



