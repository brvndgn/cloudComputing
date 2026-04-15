targetScope = 'resourceGroup'

param functionAppName string
param location string
param storageAccountName string
param storageAccountResourceGroup string
param runtimeStack string
param runtimeVersion string
param hostingPlanSku string

var storageAccountKey = listKeys(resourceId(storageAccountResourceGroup, 'Microsoft.Storage/storageAccounts', storageAccountName), '2023-01-01').keys[0].value
var connectionString = 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${storageAccountKey};EndpointSuffix=core.windows.net'

resource functionApp 'Microsoft.Web/sites@2023-01-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: hostingPlan.id
    siteConfig: {
      alwaysOn: false
      http20Enabled: true
      functionAppScaleLimit: 200
      minimumElasticInstanceCount: 0
      ftpsState: 'AllAllowed'
      use32BitWorkerProcess: false
      connectionStrings: [
        {
          name: 'AzureWebJobsStorage'
          connectionString: connectionString
          type: 'Custom'
        }
      ]
    }
    httpsOnly: false
    clientAffinityEnabled: false
  }
}

resource hostingPlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: '${functionAppName}-plan'
  location: location
  sku: {
    name: hostingPlanSku
    tier: 'Dynamic'
  }
  properties: {
    reserved: false
  }
}

output functionAppName string = functionApp.name
output functionAppId string = functionApp.id
output defaultHostname string = functionApp.properties.defaultHostName
