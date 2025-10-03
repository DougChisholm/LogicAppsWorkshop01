@description('Name of the Logic App workflow. Must be globally unique within the region.')
param workflowName string = 'ladctest001'

@description('Azure region where the Logic App will be deployed.')
param location string = resourceGroup().location

@description('Optional tags to apply to the Logic App resource.')
param tags object = {
  environment: 'workshop'
}

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: workflowName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    definition: any({
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {}
      triggers: {
        manual: {
          type: 'Request'
          kind: 'Http'
          inputs: {
            schema: {}
          }
        }
      }
      actions: {}
      outputs: {}
    })
    parameters: {}
    state: 'Enabled'
  }
  tags: tags
}

output workflowResourceId string = logicApp.id
output workflowIdentityPrincipalId string = logicApp.identity.principalId
