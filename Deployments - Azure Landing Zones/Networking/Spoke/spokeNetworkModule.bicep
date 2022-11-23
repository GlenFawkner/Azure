//Parameters
param location string = resourceGroup().location
param environmentName string 
param locationSuffix string 
param spokeaddressSpace string
param dmzAddressSpace string
param frontendAddressSpace string
param backendAddressSpace string

//Create dmz nsg
resource nsgDMZ 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-snet-${environmentName}-${locationSuffix}-dmz'
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
//       {
//         name: 'Allow_Bastion_8080'
//         properties: {
//             protocol: '*'
//             sourcePortRange: '*'
//             destinationPortRange: '8080'
//             sourceAddressPrefix: 'VirtualNetwork'
//             destinationAddressPrefix: 'VirtualNetwork'
//             access: 'Allow'
//             priority: 4093
//             direction: 'Inbound'
//         }
//     }
//     {
//       name: 'Allow_Bastion_5701'
//       properties: {
//           protocol: '*'
//           sourcePortRange: '*'
//           destinationPortRange: '5701'
//           sourceAddressPrefix: 'VirtualNetwork'
//           destinationAddressPrefix: 'VirtualNetwork'
//           access: 'Allow'
//           priority: 4092
//           direction: 'Inbound'
//       }
//   }
//   {
//     name: 'Allow_Bastion_443'
//     properties: {
//         protocol: '*'
//         sourcePortRange: '*'
//         destinationPortRange: '443'
//         sourceAddressPrefix: 'GatewayManager'
//         destinationAddressPrefix: 'VirtualNetwork'
//         access: 'Allow'
//         priority: 4091
//         direction: 'Inbound'
//     }
// }
      ]
  }   
}


//Create frontend nsg
resource nsgFrontEnd 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-snet-${environmentName}-${locationSuffix}-frontend'
  location: location
  properties: {
      securityRules: [
        {
          name: 'Deny_All_Inbound'
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
          name: 'Allow_AzureHealthProbe'
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
//       {
//         name: 'Allow_Bastion_8080'
//         properties: {
//             protocol: '*'
//             sourcePortRange: '*'
//             destinationPortRange: '8080'
//             sourceAddressPrefix: 'VirtualNetwork'
//             destinationAddressPrefix: 'VirtualNetwork'
//             access: 'Allow'
//             priority: 4093
//             direction: 'Inbound'
//         }
//     }
//     {
//       name: 'Allow_Bastion_5701'
//       properties: {
//           protocol: '*'
//           sourcePortRange: '*'
//           destinationPortRange: '5701'
//           sourceAddressPrefix: 'VirtualNetwork'
//           destinationAddressPrefix: 'VirtualNetwork'
//           access: 'Allow'
//           priority: 4092
//           direction: 'Inbound'
//       }
//   }
//   {
//     name: 'Allow_Bastion_443'
//     properties: {
//         protocol: '*'
//         sourcePortRange: '*'
//         destinationPortRange: '443'
//         sourceAddressPrefix: 'GatewayManager'
//         destinationAddressPrefix: 'VirtualNetwork'
//         access: 'Allow'
//         priority: 4091
//         direction: 'Inbound'
//     }
// }
      ]
  }   
}


//Create backend nsg
resource nsgbackend 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-snet-${environmentName}-${locationSuffix}-backend'
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
        {
          name: 'DenyAllOutbound'
          properties: {
            protocol: '*'
            sourcePortRange: '*'
            destinationPortRange: '*'
            sourceAddressPrefix: '*'
            destinationAddressPrefix: '*'
            access: 'Deny'
            priority: 4096
            direction: 'Outbound'
          }
        }
  //       {
  //         name: 'Allow_Bastion_8080'
  //         properties: {
  //             protocol: '*'
  //             sourcePortRange: '*'
  //             destinationPortRange: '8080'
  //             sourceAddressPrefix: 'VirtualNetwork'
  //             destinationAddressPrefix: 'VirtualNetwork'
  //             access: 'Allow'
  //             priority: 4093
  //             direction: 'Inbound'
  //         }
  //     }
  //     {
  //       name: 'Allow_Bastion_5701'
  //       properties: {
  //           protocol: '*'
  //           sourcePortRange: '*'
  //           destinationPortRange: '5701'
  //           sourceAddressPrefix: 'VirtualNetwork'
  //           destinationAddressPrefix: 'VirtualNetwork'
  //           access: 'Allow'
  //           priority: 4092
  //           direction: 'Inbound'
  //       }
  //   }
  //   {
  //     name: 'Allow_Bastion_443'
  //     properties: {
  //         protocol: '*'
  //         sourcePortRange: '*'
  //         destinationPortRange: '443'
  //         sourceAddressPrefix: 'GatewayManager'
  //         destinationAddressPrefix: 'VirtualNetwork'
  //         access: 'Allow'
  //         priority: 4091
  //         direction: 'Inbound'
  //     }
  // }
      ]
  }   
}


//Create spoke network 
resource virtualnetwork 'Microsoft.Network/virtualNetworks@2021-03-01'= {
  name: 'vnet-${environmentName}-${locationSuffix}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        spokeaddressSpace
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
        name: 'snet-${environmentName}-${locationSuffix}-frontend'
        properties: {
          addressPrefix: frontendAddressSpace
          networkSecurityGroup: {
            id: nsgFrontEnd.id
          }
        }
      }
      {
        name: 'snet-${environmentName}-${locationSuffix}-backend'
        properties: {
          addressPrefix: backendAddressSpace
          networkSecurityGroup: {
            id: nsgbackend.id
          }
        }
      }
    ]
  }
}

output spokevnetname string = virtualnetwork.name
output spokevnetid string = virtualnetwork.id

