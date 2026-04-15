targetScope = 'subscription'
param rgName string
param storageName string
param location string
param storageSku string
param storageKind string
param storageMinTlsVersion string

// Parameters for Poland Central blob storage
param rgNamePoland string
param storageNamePoland string
param locationPoland string
param storageSkuPoland string
param storageKindPoland string
param storageMinTlsVersionPoland string
param containerNamePoland string

// Parameters for Function App
param functionAppName string
param runtimeStack string
param runtimeVersion string
param hostingPlanSku string

// Parameters for Cosmos DB
param cosmosDbAccountName string
param cosmosDbWorkloadType string

// Parameters for Cosmos DB Container
param cosmosDbDatabaseName string
param cosmosDbContainerName string
param cosmosDbPartitionKey string
param enablePartitionMerge bool

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}

module storageAccountModule 'modules/storageAccount.bicep' = {
  name: 'storageAccountDeployment'
  scope: rg
  params: {
    storageName: storageName
    location: location
    storageSku: storageSku
    storageKind: storageKind
    storageMinTlsVersion: storageMinTlsVersion
  }
}

output storageAccountId string = storageAccountModule.outputs.storageAccountId
output storageAccountName string = storageAccountModule.outputs.storageAccountName

// Poland Central resource group and blob storage
resource rgPoland 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgNamePoland
  location: locationPoland
}

module storageAccountPolandModule 'modules/storageAccount.bicep' = {
  name: 'storageAccountDeployment'
  scope: rgPoland
  params: {
    storageName: storageNamePoland
    location: locationPoland
    storageSku: storageSkuPoland
    storageKind: storageKindPoland
    storageMinTlsVersion: storageMinTlsVersionPoland
  }
}

module storageContainerModule 'modules/storageContainer.bicep' = {
  name: 'storageContainerDeployment'
  scope: rgPoland
  params: {
    storageAccountName: storageNamePoland
    containerName: containerNamePoland
  }
  dependsOn: [
    storageAccountPolandModule
  ]
}

output storageAccountPolandId string = storageAccountPolandModule.outputs.storageAccountId
output storageAccountPolandName string = storageAccountPolandModule.outputs.storageAccountName
output blobContainerName string = storageContainerModule.outputs.containerName

// Function App in Poland Central resource group
module functionAppModule 'modules/functionApp.bicep' = {
  name: 'functionAppDeployment'
  scope: rgPoland
  params: {
    functionAppName: functionAppName
    location: locationPoland
    storageAccountName: storageNamePoland
    storageAccountResourceGroup: rgNamePoland
    runtimeStack: runtimeStack
    runtimeVersion: runtimeVersion
    hostingPlanSku: hostingPlanSku
  }
  dependsOn: [
    storageAccountPolandModule
  ]
}

output functionAppName string = functionAppModule.outputs.functionAppName
output functionAppId string = functionAppModule.outputs.functionAppId
output functionAppHostname string = functionAppModule.outputs.defaultHostname

// Cosmos DB in Poland Central resource group
module cosmosDbModule 'modules/cosmosDb.bicep' = {
  name: 'cosmosDbDeployment'
  scope: rgPoland
  params: {
    accountName: cosmosDbAccountName
    location: locationPoland
    workloadType: cosmosDbWorkloadType
  }
}

output cosmosDbAccountName string = cosmosDbModule.outputs.cosmosDbAccountName
output cosmosDbAccountId string = cosmosDbModule.outputs.cosmosDbAccountId
output cosmosDbConnectionString string = cosmosDbModule.outputs.connectionString
output cosmosDbDocumentEndpoint string = cosmosDbModule.outputs.documentEndpoint

// Cosmos DB Container in Poland Central resource group
module cosmosDbContainerModule 'modules/cosmosDbContainer.bicep' = {
  name: 'cosmosDbContainerDeployment'
  scope: rgPoland
  params: {
    cosmosDbAccountName: cosmosDbAccountName
    databaseName: cosmosDbDatabaseName
    containerName: cosmosDbContainerName
    partitionKeyPath: cosmosDbPartitionKey
  }
  dependsOn: [
    cosmosDbModule
  ]
}

output cosmosDbDatabaseName string = cosmosDbContainerModule.outputs.databaseName
output cosmosDbContainerName string = cosmosDbContainerModule.outputs.containerName
output cosmosDbDatabaseId string = cosmosDbContainerModule.outputs.databaseId
output cosmosDbContainerId string = cosmosDbContainerModule.outputs.containerId
output cosmosDbPartitionKey string = cosmosDbContainerModule.outputs.partitionKey
