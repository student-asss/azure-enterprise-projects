param appName string
param location string = resourceGroup().location
param appServicePlanId string
param runtime string = 'PYTHON|3.13'

resource webApp 'Microsoft.Web/sites@2024-11-01' = {
  name: appName
  location: location
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlanId
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: runtime
      alwaysOn: false
      http20Enabled: true
    }
  }
}

resource webConfig 'Microsoft.Web/sites/config@2024-11-01' = {
  parent: webApp
  name: 'web'
  properties: {
    linuxFxVersion: runtime
    ftpsState: 'FtpsOnly'
    minTlsVersion: '1.2'
  }
}
