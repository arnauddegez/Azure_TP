# !/bin/bash

#Ce scrypt permet de déployer l'ensemble des ressources 
#necessaire au bon fonctionnement d'une appli flask

#Variables:
group_name="tp2-arnaud-rg"
location="eastus"
group_test=$(az group exists --name $group_name)


if $group_test == true; then
    echo "$(date +'%Y-%m-%d %H:%M:%S') [ INFO  ] : Le groupe existe déjà ..."

else
echo "$(date +'%Y-%m-%d %H:%M:%S') [ INFO  ] : Création du groupe de ressource ..."
az group create \
--name $group_name \
--location $location
fi
#Deploiement de la vm + network (vnet,subnet,nat gateway, etc...)
az deployment group create \
--resource-group $group_name \
--template-file  azuredeploy.json \
--parameters azuredeployparameters.json \
customData="`base64 -w 0 Cloud-Init`"


