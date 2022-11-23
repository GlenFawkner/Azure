targetScope = 'subscription'

@description('Azure Region where Resource Group will be created.')
param parLocation string

@description('Name of Resource Group to be created.')
param parResourceGroupName string


resource resResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  location: parLocation
  name: parResourceGroupName
}


output outResourceGroupName string = resResourceGroup.name
output outResourceGroupId string = resResourceGroup.id
