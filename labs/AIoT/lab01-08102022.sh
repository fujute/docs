# Variable block
let "randomIdentifier=$RANDOM*$RANDOM"
location="East Asia"
resourceGroup="1-SQL-fuju-rg"
server="msdocs-azuresql-server-$randomIdentifier"
database="msdocsazuresqldb$randomIdentifier"
login="azureuser"
password="Pa$$w0rD-$randomIdentifier"

echo "Using resource group $resourceGroup with login: $login, password: $password..."

az group create --name "$resourceGroup" --location "$location"


# 2.	Creating server

echo "Creating $server in $location..."
az sql server create --name $server --resource-group $resourceGroup --location "$location" --admin-user $login --admin-password $password

#3.	Creating Database (will create database with AdventureWorks sample data) 
#And type “y” for Geo-redundant storage

echo "Creating $database in serverless tier"
az sql db create --resource-group $resourceGroup \
 --server $server --name $database \
 --sample-name AdventureWorksLT --edition GeneralPurpose \
 --compute-model Serverless \
 --family Gen5 --capacity 2


az vm create \
    --resource-group $resourceGroup \
    --location "$location" \
    --name testVMfuju001 \
    --image microsoft-dsvm:dsvm-windows:server-2019:latest \
    --size Standard_DS2_v2 \
    --public-ip-sku Standard \
    --admin-username $login \
    --admin-password $password \
    --nsg-rule RDP \
    --priority Spot # low priority, cheaper cost for dev/test
