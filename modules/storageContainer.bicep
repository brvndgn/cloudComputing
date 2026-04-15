targetScope = 'resourceGroup'

param storageAccountName string
param containerName string

resource blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  name: '${storageAccountName}/default/${containerName}'
  properties: {
    publicAccess: 'Container'
  }
}

output containerName string = containerName
