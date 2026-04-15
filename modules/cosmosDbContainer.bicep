targetScope = 'resourceGroup'

param cosmosDbAccountName string
param databaseName string
param containerName string
param partitionKeyPath string

// Create the database
resource cosmosDbDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2023-11-15' = {
  name: '${cosmosDbAccountName}/${databaseName}'
  properties: {
    resource: {
      id: databaseName
    }
  }
}

// Create the container
resource cosmosDbContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2023-11-15' = {
  parent: cosmosDbDatabase
  name: containerName
  properties: {
    resource: {
      id: containerName
      partitionKey: {
        paths: [
          partitionKeyPath
        ]
        kind: 'Hash'
      }
      indexingPolicy: {
        indexingMode: 'consistent'
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/"_etag"/?'
          }
        ]
      }
      defaultTtl: -1
      uniqueKeyPolicy: {
        uniqueKeys: []
      }
    }
    options: {
      throughput: 400
    }
  }
}

output databaseName string = cosmosDbDatabase.name
output containerName string = cosmosDbContainer.name
output databaseId string = databaseName
output containerId string = containerName
output partitionKey string = partitionKeyPath
