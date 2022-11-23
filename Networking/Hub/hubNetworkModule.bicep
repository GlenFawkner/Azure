//Parameters
param location string = resourceGroup().location
param environmentName string 
param locationSuffix string 
param hubaddressSpace string
param gatewayAddressSpace string
param bastionAddressSpace string
param dmzAddressSpace string

//Create dmz nsg
resource nsgDMZ 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-snet-${environmentName}-dmz'
  location: location
  properties: {
      securityRules: [
        {
          name: 'DenyAllInbound'
          properties: {
            protocol: '*'
            sourcePortRange: '*'
            destinationPortRange: '*'
            sourceAddressPrefix: '*'
            destinationAddressPrefix: '*'
            access: 'Deny'
            priority: 4096
            direction: 'Inbound'
          }
        }
        {
          name: 'AzureHealthProbe'
          properties: {
              protocol: '*'
              sourcePortRange: '*'
              destinationPortRange: '*'
              sourceAddressPrefix: 'AzureLoadBalancer'
              destinationAddressPrefix: '*'
              access: 'Allow'
              priority: 4095
              direction: 'Inbound'
          }
      }
      ]
  }   
}

//Create hub network and attach nsgs
resource virtualnetwork 'Microsoft.Network/virtualNetworks@2021-03-01'= {
  name: 'vnet-${environmentName}-${locationSuffix}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        hubaddressSpace
      ]
    }
    
    subnets: [
      {
        name: 'snet-${environmentName}-${locationSuffix}-dmz'
        properties: {
          addressPrefix: dmzAddressSpace
          networkSecurityGroup: {
            id: nsgDMZ.id
          }
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: bastionAddressSpace
        }
      }
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: gatewayAddressSpace
        }
      }
    ]
  }
}

output hubvnetname string = virtualnetwork.name
output hubvnetid string = virtualnetwork.id
output vnetname string = virtualnetwork.name
