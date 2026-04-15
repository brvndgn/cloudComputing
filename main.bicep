targetScope = 'subscription'
param subscriptionName string
param subscriptionId string
param providers array
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

module blobStorageAccountModule 'modules/blobStorageAccount.bicep' = {
  name: 'blobStorageAccountDeployment'
  scope: rgPoland
  params: {
    storageName: storageNamePoland
    location: locationPoland
    storageSku: storageSkuPoland
    storageKind: storageKindPoland
    storageMinTlsVersion: storageMinTlsVersionPoland
    containerName: containerNamePoland
  }
}

output blobStorageAccountId string = blobStorageAccountModule.outputs.storageAccountId
output blobStorageAccountName string = blobStorageAccountModule.outputs.storageAccountName
output blobContainerName string = blobStorageAccountModule.outputs.containerName
