param serverfarms_asp_s01_free_name string

resource serverfarms_asp_s01_free_name_resource 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: serverfarms_asp_s01_free_name
  location: 'Sweden Central'
  sku: {
    name: 'F1'
    tier: 'Free'
    size: 'F1'
    family: 'F'
    capacity: 1
  }
  kind: 'linux'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: true
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
    asyncScalingEnabled: false
  }
}
