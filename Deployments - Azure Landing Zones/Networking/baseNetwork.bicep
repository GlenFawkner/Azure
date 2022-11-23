//Deployment base hub and spoke network
//Parameters
// Global parameters
param location string = 'australiaeast'
param locationSuffix string = ''
// Connectivity parameters
param connectivitysubscription string = ''
param connectivityenvironmentName string = ''
param connectivityaddressSpace string = ''
param gatewayAddressSpace string = ''
param bastionAddressSpace string = ''
param dmzAddressSpace string = ''
// Production parameters
param productionSubscription string = ''
param productionEnvironmentName string = ''
param productionAddressSpace string = ''
param productionDMZAddressSpace string = ''
param productionFrontendAddressSpace string = ''
param productionBackendAddressSpace string = ''
// Identity parameters
param identitySubscription string = ''
param identityEnvironmentName string = ''
param identityAddressSpace string = ''
param identityDMZAddressSpace string = ''
param identityFrontendAddressSpace string = ''
param identityBackendAddressSpace string = ''
// Non Production parameters
param nonProductionSubscription string = ''
param nonProductionEnvironmentName string = ''
param nonProductionAddressSpace string = ''
param nonProductionDMZAddressSpace string = ''
param nonProductionFrontendAddressSpace string = ''
param nonProductionBackendAddressSpace string = ''

// Target scope
targetScope = 'subscription'

//Create resource groups
// Connectivity resource group
module connectivityRG '../Resource Groups/resourceGroup.bicep' = {
  name:'connectivityRG'
  params:{
    parLocation:location
    parResourceGroupName:'rg-${connectivityenvironmentName}-networking-${locationSuffix}'
  }
}
// Production resource group
module productionRG '../Resource Groups/resourceGroup.bicep' = {
  name:'productionRG'
  params:{
    parLocation:location
    parResourceGroupName:'rg-${productionEnvironmentName}-networking-${locationSuffix}'
  }
}
// Identity resource group
module identityRG '../Resource Groups/resourceGroup.bicep' = {
  name:'identityRG'
  params:{
    parLocation:location
    parResourceGroupName:'rg-${identityEnvironmentName}-networking-${locationSuffix}'
  }
}
// Non production resource group
module nonprodRG '../Resource Groups/resourceGroup.bicep' = {
  name:'nonProdRG'
  params:{
    parLocation:location
    parResourceGroupName:'rg-${nonProductionEnvironmentName}-networking-${locationSuffix}'
  }
}
// Create hub network
module connectivityModule './Hub/HubNetworkModule.bicep' = {
  name:'HubNetworkDeploy'
  params: {
      environmentName: connectivityenvironmentName
      locationSuffix: locationSuffix
      hubaddressSpace: connectivityaddressSpace
      gatewayAddressSpace: gatewayAddressSpace
      bastionAddressSpace: bastionAddressSpace
      dmzAddressSpace: dmzAddressSpace
      location: location
  }
  scope:resourceGroup(connectivitysubscription,'rg-${connectivityenvironmentName}-networking-${locationSuffix}')
}

//Create spoke network
module prodModule './Spoke/SpokeNetworkModule.bicep' = {
  name:'SpokeNetworkDeploy'
  params:{
    environmentName: productionEnvironmentName
    locationSuffix: locationSuffix
    spokeaddressSpace: productionAddressSpace
    dmzAddressSpace: productionDMZAddressSpace
    frontendAddressSpace: productionFrontendAddressSpace
    backendAddressSpace: productionBackendAddressSpace
    location: location
  }
  scope:resourceGroup(productionSubscription,'rg-${productionEnvironmentName}-networking-${locationSuffix}')
}

// Create Identity Network
module identityModule './Spoke/SpokeNetworkModule.bicep' = {
  name:'idNetworkDeploy'
  params:{
    environmentName: identityEnvironmentName
    locationSuffix: locationSuffix
    spokeaddressSpace: identityAddressSpace
    dmzAddressSpace: identityDMZAddressSpace
    frontendAddressSpace: identityFrontendAddressSpace
    backendAddressSpace: identityBackendAddressSpace
    location: location
  }
  scope:resourceGroup(identitySubscription,'rg-${identityEnvironmentName}-networking-${locationSuffix}')
}

// Create Non Production Network
module nonProdModule './Spoke/SpokeNetworkModule.bicep' = {
  name:'idNetworkDeploy'
  params:{
    environmentName: nonProductionEnvironmentName
    locationSuffix: locationSuffix
    spokeaddressSpace: nonProductionAddressSpace
    dmzAddressSpace: nonProductionDMZAddressSpace
    frontendAddressSpace: nonProductionFrontendAddressSpace
    backendAddressSpace: nonProductionBackendAddressSpace
    location: location
  }
  scope:resourceGroup(nonProductionSubscription,'rg-${nonProductionEnvironmentName}-networking-${locationSuffix}')
}


// //Create hub to production network peering
module hubprodPeerModule './hub/hubvnetPeeringModule.bicep' = {
  name:'HubProdPeering'
  scope:resourceGroup(connectivitysubscription,'rg-${connectivityenvironmentName}-networking-${locationSuffix}')
  params:{
    localVNETname:connectivityModule.outputs.hubvnetname
    remoteVNETid:prodModule.outputs.spokevnetid
    remoteVNETName:prodModule.outputs.spokevnetname
  }
  dependsOn: [
    prodModule
  ]
}

// //Create production to hub peering
module prodPeerModule './Spoke/spokeVNETPeeringModule.bicep' = {
  name:'prodPeering'
  scope:resourceGroup(productionSubscription,'rg-${productionEnvironmentName}-networking-${locationSuffix}')
  params:{
    localVNETname:prodModule.outputs.spokevnetname
    remoteVNETid:connectivityModule.outputs.hubvnetid
    remoteVNETName:connectivityModule.outputs.hubvnetname
  }
  dependsOn: [
    prodModule
  ]
}

// //Create hub to identity network peering
module hubidPeerModule './hub/hubvnetPeeringModule.bicep' = {
  name:'HubIdPeering'
  scope:resourceGroup(connectivitysubscription,'rg-${connectivityenvironmentName}-networking-${locationSuffix}')
  params:{
    localVNETname:connectivityModule.outputs.hubvnetname
    remoteVNETid:identityModule.outputs.spokevnetid
    remoteVNETName:identityModule.outputs.spokevnetname
  }
  dependsOn: [
    identityModule
  ]
}

// //Create identity to hub peering
module idPeerModule './Spoke/spokeVNETPeeringModule.bicep' = {
  name:'idPeering'
  scope:resourceGroup(identitySubscription,'rg-${identityEnvironmentName}-networking-${locationSuffix}')
  params:{
    localVNETname:identityModule.outputs.spokevnetname
    remoteVNETid:connectivityModule.outputs.hubvnetid
    remoteVNETName:connectivityModule.outputs.hubvnetname
  }
  dependsOn: [
    identityModule
  ]
}
// //Create hub to identity network peering
module hubNonProdPeerModule './hub/hubvnetPeeringModule.bicep' = {
  name:'HubNonProdPeering'
  scope:resourceGroup(connectivitysubscription,'rg-${connectivityenvironmentName}-networking-${locationSuffix}')
  params:{
    localVNETname:connectivityModule.outputs.hubvnetname
    remoteVNETid:nonProdModule.outputs.spokevnetid
    remoteVNETName:nonProdModule.outputs.spokevnetname
  }
  dependsOn: [
    nonProdModule
  ]
}

// //Create identity to hub peering
module nonProdPeerModule './Spoke/spokeVNETPeeringModule.bicep' = {
  name:'idPeering'
  scope:resourceGroup(nonProductionSubscription,'rg-${nonProductionEnvironmentName}-networking-${locationSuffix}')
  params:{
    localVNETname:nonProdModule.outputs.spokevnetname
    remoteVNETid:connectivityModule.outputs.hubvnetid
    remoteVNETName:connectivityModule.outputs.hubvnetname
  }
  dependsOn: [
    nonProdModule
  ]
}
