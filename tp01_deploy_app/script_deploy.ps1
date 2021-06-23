#variables
$group_name= "tp1-arnaud-rg"
$location= "eastus"
$group_test=$(az group exists --name $group_name)
$group_vnet= "tp1-arnaud-vnet"
$group_subnet= "tp1-arnaud-subnet"
$vm_name= "tp1-arnaud-vm"
$vm_test=$(az vm list --name $vm_name)
$vm_image= "Debian"
$vm_root= "Student"
$vm_type= "Standard_DS1_v2"

#creation du groupe de ressource 
if ( $group_test -ne $true )
{
    az group create -l $location -n $group_name
    az network vnet create --resource-group $group_name --name $group_vnet --address-prefix 10.80.0.0/16 --subnet-name $group_subnet --subnet-prefix 10.80.1.0/24
}

#creation de la vm linux
if ( $vm_test -ne $true )
{
    az vm create --resource-group $group_name --name $vm_name --image $vm_image --admin-username $vm_root --generate-ssh-keys --size $vm_type
    az vm extension set --publisher Microsoft.Azure.Extensions --version 2.0 --name CustomScript --vm-name $vm_name --resource-group $group_name --settings 
    '{
        "commandToExecute": {
            "curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -",
            "sudo apt-get install -y nodejs",
            "sudo npm install -g pm2",
            "sudo apt-get install -y nginx",
            "sudo pm2 start -f index.js",
            "mkdir /home/app/",
            "git clone https://github.com/Azure-Samples/nodejs-docs-hello-world.git > /home/app/",
        }
    }'

}