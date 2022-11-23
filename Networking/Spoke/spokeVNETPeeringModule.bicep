//Create hub VNET peering
//Parameters
param localVNETname string 
param remoteVNETid string 
param remoteVNETName string

resource spoke_peering_to_remote_VNET 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
    name: '${localVNETname}_to_${remoteVNETName}'
    properties: {
      allowVirtualNetworkAccess: true
      allowForwardedTraffic: true
      allowGatewayTransit: false
      useRemoteGateways: true
      remoteVirtualNetwork: {
        id: remoteVNETid
      }
    }
  }
