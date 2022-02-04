#!/bin/bash

set -xe

RESOURCE_GROUP=${RESOURCE_GROUP:-iago-test-nomad}

az group create --name ${RESOURCE_GROUP} --location northeurope
az network vnet create --resource-group ${RESOURCE_GROUP} --name nomad-vnet --subnet-name nomad-subnet
az network public-ip create --resource-group ${RESOURCE_GROUP} --name nomad-publicIP
az network nsg create --resource-group ${RESOURCE_GROUP} --name nomad-nsg

az network nic create --resource-group ${RESOURCE_GROUP} --name nomad-server-1-nic --vnet-name nomad-vnet --subnet nomad-subnet --network-security-group nomad-nsg --public-ip-address nomad-publicip
az network nic ip-config update --name ipconfig1 --resource-group ${RESOURCE_GROUP} --nic-name nomad-server-1-nic --private-ip-address 10.0.0.4
az vm create --name nomad-server-1 --resource-group ${RESOURCE_GROUP} --admin-username core --custom-data "$(cat server-1.ign)" --image kinvolk:flatcar-container-linux:stable:3033.2.0 --nics nomad-server-1-nic
az vm open-port --port 22 --resource-group ${RESOURCE_GROUP} --name nomad-server-1

az network nic create --resource-group ${RESOURCE_GROUP} --name nomad-server-2-nic --vnet-name nomad-vnet --subnet nomad-subnet --network-security-group nomad-nsg
az network nic ip-config update --name ipconfig1 --resource-group ${RESOURCE_GROUP} --nic-name nomad-server-2-nic --private-ip-address 10.0.0.5
az vm create --name nomad-server-2 --resource-group ${RESOURCE_GROUP} --admin-username core --custom-data "$(cat server-2.ign)" --image kinvolk:flatcar-container-linux:stable:3033.2.0 --nics nomad-server-2-nic

az network nic create --resource-group ${RESOURCE_GROUP} --name nomad-server-3-nic --vnet-name nomad-vnet --subnet nomad-subnet --network-security-group nomad-nsg
az network nic ip-config update --name ipconfig1 --resource-group ${RESOURCE_GROUP} --nic-name nomad-server-3-nic --private-ip-address 10.0.0.6
az vm create --name nomad-server-3 --resource-group ${RESOURCE_GROUP} --admin-username core --custom-data "$(cat server-3.ign)" --image kinvolk:flatcar-container-linux:stable:3033.2.0 --nics nomad-server-3-nic

az network nic create --resource-group ${RESOURCE_GROUP} --name nomad-client-1-nic --vnet-name nomad-vnet --subnet nomad-subnet --network-security-group nomad-nsg
az network nic ip-config update --name ipconfig1 --resource-group ${RESOURCE_GROUP} --nic-name nomad-client-1-nic --private-ip-address 10.0.0.7
az vm create --name nomad-client-1 --resource-group ${RESOURCE_GROUP} --admin-username core --custom-data "$(cat client-1.ign)" --image kinvolk:flatcar-container-linux:stable:3033.2.0 --nics nomad-client-1-nic

az network nic create --resource-group ${RESOURCE_GROUP} --name nomad-client-2-nic --vnet-name nomad-vnet --subnet nomad-subnet --network-security-group nomad-nsg
az network nic ip-config update --name ipconfig1 --resource-group ${RESOURCE_GROUP} --nic-name nomad-client-2-nic --private-ip-address 10.0.0.8
az vm create --name nomad-client-2 --resource-group ${RESOURCE_GROUP} --admin-username core --custom-data "$(cat client-2.ign)" --image kinvolk:flatcar-container-linux:stable:3033.2.0 --nics nomad-client-2-nic

az network nic create --resource-group ${RESOURCE_GROUP} --name nomad-client-3-nic --vnet-name nomad-vnet --subnet nomad-subnet --network-security-group nomad-nsg
az network nic ip-config update --name ipconfig1 --resource-group ${RESOURCE_GROUP} --nic-name nomad-client-3-nic --private-ip-address 10.0.0.9
az vm create --name nomad-client-3 --resource-group ${RESOURCE_GROUP} --admin-username core --custom-data "$(cat client-3.ign)" --image kinvolk:flatcar-container-linux:stable:3033.2.0 --nics nomad-client-3-nic
