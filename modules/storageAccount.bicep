targetScope = 'resourceGroup'

param storageName string
param location string
param storageSku string
param storageKind string
param storageMinTlsVersion string

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

output storageAccountId string = storageAccount.id
output storageAccountName string = storageAccount.name
