targetScope = 'resourceGroup'

param accountName string
param location string
param workloadType string = 'Production'

resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2023-11-15' = {
  name: accountName
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
      maxStalenessPrefix: 100
      maxIntervalInSeconds: 5
    }
    enableAutomaticFailover: false
    enableMultipleWriteLocations: false
    isVirtualNetworkFilterEnabled: false
    disableKeyBasedMetadataWriteAccess: false
    enableFreeTier: workloadType == 'Learning'
    enableAnalyticalStorage: false
    enablePartitionMerge: true
    backupPolicy: {
      type: 'Periodic'
      periodicModeProperties: {
        backupIntervalInMinutes: 240
        backupRetentionIntervalInHours: 8
        backupStorageRedundancy: 'Local'
      }
    }
    cors: []
    networkAclBypass: 'None'
    networkAclBypassResourceIds: []
  }
}

output cosmosDbAccountName string = cosmosDbAccount.name
output cosmosDbAccountId string = cosmosDbAccount.id
output primaryMasterKey string = cosmosDbAccount.listKeys().primaryMasterKey
output secondaryMasterKey string = cosmosDbAccount.listKeys().secondaryMasterKey
output primaryReadonlyMasterKey string = cosmosDbAccount.listKeys().primaryReadonlyMasterKey
output secondaryReadonlyMasterKey string = cosmosDbAccount.listKeys().secondaryReadonlyMasterKey
output connectionString string = cosmosDbAccount.listConnectionStrings().connectionStrings[0].connectionString
output documentEndpoint string = cosmosDbAccount.properties.documentEndpoint
