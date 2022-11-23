//Create hub vnet peering
//Parameters
param localVNETname string 
param remoteVNETid string 
param remoteVNETName string 

resource hub_peering_to_remote_vnet 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
    name: '${localVNETname}_to_${remoteVNETName}'
    properties: {
      allowVirtualNetworkAccess: true
      allowForwardedTraffic: true
      allowGatewayTransit: true
      useRemoteGateways: false
      remoteVirtualNetwork: {
        id: remoteVNETid
      }
    }
  }
