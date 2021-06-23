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
vm_test=$(az vm list -d -o table --query "[?name=='$vm_name']")
vm_image="Debian"
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
sleep 180s
fi



#creation d'une VM windows linux avec nodeje et nginx
if [$vm_test = $vm_name ] ; then
    echo "$(date +'%Y-%m-%d %H:%M:%S') [ INFO  ] : La vm existe déjà ..."
else
    az vm create \
        --resource-group $group_name \
        --name $vm_name \
        --image $vm_image \
        --admin-username $vm_root \
        --generate-ssh-keys \
        --size $vm_type \
        --custom-data cloud-init.txt
fi

# #Ouverture port 80 vm
# az vm open-port --port 80 --resource-group $group_name --name $vm_name




