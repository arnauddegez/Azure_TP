#variables
$group_name= "tp1-arnaud-rg"
$location= "eastus"
$group_test=$(az group exists --name $group_name)
$group_vnet= "tp1-arnaud-vnet"
$group_subnet= "tp1-arnaud-subnet"
$vm_name= "tp1-arnaud-vm"
$vm_image= "UbuntuLTS"
$vm_root="azureuser"
$vm_type= "Standard_DS1_v2"

#creation du groupe de ressource 
if ( $group_test -ne $true )
{
    az group create -l $location -n $group_name
    az network vnet create --resource-group $group_name --name $group_vnet --address-prefix 10.80.0.0/16 --subnet-name $group_subnet --subnet-prefix 10.80.1.0/24 
}

az vm create --resource-group $group_name --name $vm_name --image $vm_image --admin-username $vm_root --generate-ssh-keys --size $vm_type --custom-data cloud-init.txt
az vm open-port --port 80 --resource-group $group_name --name $vm_name --priority 100
az vm list-ip-addresses -g $group_name -n $vm_name