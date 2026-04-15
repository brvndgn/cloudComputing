targetScope = 'resourceGroup'

param storageName string
param location string
param storageSku string
param storageKind string
param storageMinTlsVersion string
param containerName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageName
  location: location
  sku: {
    name: storageSku
  }
  kind: storageKind
  properties: {
    minimumTlsVersion: storageMinTlsVersion
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: true
  }
}

resource blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  name: '${storageAccount.name}/default/${containerName}'
  properties: {
    publicAccess: 'Container'
  }
}

output storageAccountId string = storageAccount.id
output storageAccountName string = storageAccount.name
output containerName string = containerName
