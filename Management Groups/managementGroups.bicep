targetScope = 'tenant'

@description('Prefix for the management group hierarchy. This management group will be created as part of the deployment. Default: alz')
@minLength(2)
@maxLength(10)
param parTopLevelManagementGroupPrefix string = 'alz'

@description('Display name for top level management group. This name will be applied to the management group prefix defined in parTopLevelManagementGroupPrefix parameter. Default: Azure Landing Zones')
@minLength(2)
param parTopLevelManagementGroupDisplayName string = 'Azure Landing Zones'

@description('Optional parent for Management Group hierarchy, used as intermediate root Management Group parent, if specified. If empty, default, will deploy beneath Tenant Root Management Group. Default: Empty String')
param parTopLevelManagementGroupParentId string = ''

@description('Deploys Production & NonProduction Management Groups beneath Landing Zones Management Group if set to true. Default: true')
param parLandingZoneMgAlzDefaultsEnable bool = true

@description('Deploys Confidential Production & Confidential NonProduction Management Groups beneath Landing Zones Management Group if set to true. Default: false')
param parLandingZoneMgConfidentialEnable bool = false

@description('Dictionary Object to allow additional or different child Management Groups of Landing Zones Management Group to be deployed. Default: Empty Object')
param parLandingZoneMgChildren object = {}


// Platform and Child Management Groups
var varPlatformMg = {
  name: '${parTopLevelManagementGroupPrefix}-platform'
  displayName: 'Platform'
}

var varPlatformManagementMg = {
  name: '${parTopLevelManagementGroupPrefix}-platform-management'
  displayName: 'Management'
}

var varPlatformConnectivityMg = {
  name: '${parTopLevelManagementGroupPrefix}-platform-connectivity'
  displayName: 'Connectivity'
}

var varPlatformIdentityMg = {
  name: '${parTopLevelManagementGroupPrefix}-platform-identity'
  displayName: 'Identity'
}

// Landing Zones & Child Management Groups
var varLandingZoneMg = {
  name: '${parTopLevelManagementGroupPrefix}-landingzones'
  displayName: 'Landing Zones'
}

// Used if parLandingZoneMgAlzDefaultsEnable == true
var varLandingZoneMgChildrenAlzDefault = {
  Production: {
    displayName: 'Production'
  }
  NonProduction: {
    displayName: 'Non-Production'
  }
}

// Used if parLandingZoneMgConfidentialEnable == true
var varLandingZoneMgChildrenConfidential = {
  'confidential-Production': {
    displayName: 'Confidential Production'
  }
  'confidential-NonProduction': {
    displayName: 'Confidential Non-Production'
  }
}

// Build final onject based on input parameters for child MGs of LZs
var varLandingZoneMgChildrenUnioned = (parLandingZoneMgAlzDefaultsEnable && parLandingZoneMgConfidentialEnable && (!empty(parLandingZoneMgChildren))) ? union(varLandingZoneMgChildrenAlzDefault, varLandingZoneMgChildrenConfidential, parLandingZoneMgChildren) : (parLandingZoneMgAlzDefaultsEnable && parLandingZoneMgConfidentialEnable && (empty(parLandingZoneMgChildren))) ? union(varLandingZoneMgChildrenAlzDefault, varLandingZoneMgChildrenConfidential) : (parLandingZoneMgAlzDefaultsEnable && !parLandingZoneMgConfidentialEnable && (!empty(parLandingZoneMgChildren))) ? union(varLandingZoneMgChildrenAlzDefault, parLandingZoneMgChildren) : (parLandingZoneMgAlzDefaultsEnable && !parLandingZoneMgConfidentialEnable && (empty(parLandingZoneMgChildren))) ? varLandingZoneMgChildrenAlzDefault : (!parLandingZoneMgAlzDefaultsEnable && parLandingZoneMgConfidentialEnable && (!empty(parLandingZoneMgChildren))) ? union(varLandingZoneMgChildrenConfidential, parLandingZoneMgChildren) : (!parLandingZoneMgAlzDefaultsEnable && parLandingZoneMgConfidentialEnable && (empty(parLandingZoneMgChildren))) ? varLandingZoneMgChildrenConfidential : (!parLandingZoneMgAlzDefaultsEnable && !parLandingZoneMgConfidentialEnable && (!empty(parLandingZoneMgChildren))) ? parLandingZoneMgChildren : (!parLandingZoneMgAlzDefaultsEnable && !parLandingZoneMgConfidentialEnable && (empty(parLandingZoneMgChildren))) ? {} : {}


// Sandbox Management Group
var varSandboxMg = {
  name: '${parTopLevelManagementGroupPrefix}-sandbox'
  displayName: 'Sandbox'
}

// // Decomissioned Management Group
// var varDecommissionedMg = {
//   name: '${parTopLevelManagementGroupPrefix}-decommissioned'
//   displayName: 'Decommissioned'
// }

// Level 1
resource resTopLevelMg 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: parTopLevelManagementGroupPrefix
  properties: {
    displayName: parTopLevelManagementGroupDisplayName
    details: {
      parent: {
        id: empty(parTopLevelManagementGroupParentId) ? '/providers/Microsoft.Management/managementGroups/${tenant().tenantId}' : parTopLevelManagementGroupParentId
      }
    }
  }
}

// Level 2
resource resPlatformMg 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varPlatformMg.name
  properties: {
    displayName: varPlatformMg.displayName
    details: {
      parent: {
        id: resTopLevelMg.id
      }
    }
  }
}

resource resLandingZonesMg 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varLandingZoneMg.name
  properties: {
    displayName: varLandingZoneMg.displayName
    details: {
      parent: {
        id: resTopLevelMg.id
      }
    }
  }
}

resource resSandboxMg 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varSandboxMg.name
  properties: {
    displayName: varSandboxMg.displayName
    details: {
      parent: {
        id: resTopLevelMg.id
      }
    }
  }
}

// resource resDecommissionedMg 'Microsoft.Management/managementGroups@2021-04-01' = {
//   name: varDecommissionedMg.name
//   properties: {
//     displayName: varDecommissionedMg.displayName
//     details: {
//       parent: {
//         id: resTopLevelMg.id
//       }
//     }
//   }
// }

// Level 3 - Child Management Groups under Platform MG
resource resPlatformManagementMg 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varPlatformManagementMg.name
  properties: {
    displayName: varPlatformManagementMg.displayName
    details: {
      parent: {
        id: resPlatformMg.id
      }
    }
  }
}

resource resPlatformConnectivityMg 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varPlatformConnectivityMg.name
  properties: {
    displayName: varPlatformConnectivityMg.displayName
    details: {
      parent: {
        id: resPlatformMg.id
      }
    }
  }
}

resource resPlatformIdentityMg 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varPlatformIdentityMg.name
  properties: {
    displayName: varPlatformIdentityMg.displayName
    details: {
      parent: {
        id: resPlatformMg.id
      }
    }
  }
}

// Level 3 - Child Management Groups under Landing Zones MG

resource resLandingZonesChildMgs 'Microsoft.Management/managementGroups@2021-04-01' = [for mg in items(varLandingZoneMgChildrenUnioned): if (!empty(varLandingZoneMgChildrenUnioned)) {
  name: '${parTopLevelManagementGroupPrefix}-landingzones-${mg.key}'
  properties: {
    displayName: mg.value.displayName
    details: {
      parent: {
        id: resLandingZonesMg.id
      }
    }
  }
}]

// Output Management Group IDs
output outTopLevelManagementGroupId string = resTopLevelMg.id

output outPlatformManagementGroupId string = resPlatformMg.id
output outPlatformManagementManagementGroupId string = resPlatformManagementMg.id
output outPlatformConnectivityManagementGroupId string = resPlatformConnectivityMg.id
output outPlatformIdentityManagementGroupId string = resPlatformIdentityMg.id

output outLandingZonesManagementGroupId string = resLandingZonesMg.id
output outLandingZoneChildrenManagementGroupIds array = [for mg in items(varLandingZoneMgChildrenUnioned): '/providers/Microsoft.Management/managementGroups/${parTopLevelManagementGroupPrefix}-landingzones-${mg.key}' ]

output outSandboxManagementGroupId string = resSandboxMg.id

// output outDecommissionedManagementGroupId string = resDecommissionedMg.id

// Output Management Group Names
output outTopLevelManagementGroupName string = resTopLevelMg.name

output outPlatformManagementGroupName string = resPlatformMg.name
output outPlatformManagementManagementGroupName string = resPlatformManagementMg.name
output outPlatformConnectivityManagementGroupName string = resPlatformConnectivityMg.name
output outPlatformIdentityManagementGroupName string = resPlatformIdentityMg.name

output outLandingZonesManagementGroupName string = resLandingZonesMg.name
output outLandingZoneChildrenManagementGroupNames array = [for mg in items(varLandingZoneMgChildrenUnioned): mg.value.displayName ]

output outSandboxManagementGroupName string = resSandboxMg.name

// output outDecommissionedManagementGroupName string = resDecommissionedMg.name