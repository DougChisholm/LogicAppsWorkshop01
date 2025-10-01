param location string = resourceGroup().location
param logicAppName string

// Reference existing storage accounts
resource publicStorage 'Microsoft.Storage/storageAccounts@2025-01-01' existing = {
  name: 'publicstorageguid123'
}

resource privateStorage 'Microsoft.Storage/storageAccounts@2025-01-01' existing = {
  name: 'privatestorageguid123'
}

// Connection for Public Storage (reader)
resource publicStorageConn 'Microsoft.Web/connections@2016-06-01' = {
  name: 'publicstorageconnector'
  location: location
  properties: {
    displayName: 'PublicStorageConnection'
    api: {
      id: subscriptionResourceId(
        'Microsoft.Web/locations/managedApis',
        location,
        'azureblob'
      )
    }
    parameterValues: {
      accountName: 'publicstorageguid123'
      accessKey: publicStorage.listKeys().keys[0].value
    }
  }
}

// Connection for Private Storage (writer)
resource privateStorageConn 'Microsoft.Web/connections@2016-06-01' = {
  name: 'privatestorageconnector'
  location: location
  properties: {
    displayName: 'PrivateStorageConnection'
    api: {
      id: subscriptionResourceId(
        'Microsoft.Web/locations/managedApis',
        location,
        'azureblob'
      )
    }
    parameterValues: {
      accountName: 'privatestorageguid123'
      accessKey: privateStorage.listKeys().keys[0].value
    }
  }
}

// Logic App (Consumption Plan)
resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: logicAppName
  location: location
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {
        '$connections': {
          defaultValue: {}
          type: 'Object'
        }
      }
      triggers: {}
      actions: {}
      outputs: {}
    }
    parameters: {
      '$connections': {
        value: {
          publicstorageconnector: {
            connectionId: publicStorageConn.id
            connectionName: publicStorageConn.name
            id: subscriptionResourceId('Microsoft.Web/locations/managedApis', location, 'azureblob')
          }
          privatestorageconnector: {
            connectionId: privateStorageConn.id
            connectionName: privateStorageConn.name  
            id: subscriptionResourceId('Microsoft.Web/locations/managedApis', location, 'azureblob')
          }
        }
      }
    }
  }

}
