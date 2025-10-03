# Logic Apps Workshop 01

This workshop shows how to use Azure Logic Apps to transform and transfer files from Azure Storage Accounts. It also includes optional elements to understand the power of Infrasctructure as Code, CICD and Azure AI Foundry for modernising legacy workflows using Generative AI.

- Create a resource group in Azure called "rg-logic-apps-workshop". 
- Install Azure CLI. 
- Using Bash (for Mac) / PowerShell (for Windows) in the terminal run the commands below to create three storage accounts.
- Add RBAC for current Azure user to put a file in on container
- Create a logic app and use its Managed Identity to give RBAC Contributor rights on both storage accounts
- Build a logic app workflow as per workflow.png to transfer files
- Optional extension: Add Azure AI Foundry action to rename the file using the prompt "describe the example file in three words as a suitable file name".

## Install Azure CLI from terminal:  
Windows: winget install --exact --id Microsoft.AzureCLI (then restart terminal)  
Mac: brew update && brew install azure-cli

Windows:
https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?view=azure-cli-latest&pivots=winget

Mac:
https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-macos?view=azure-cli-latest

**Using Terminal, Login to Azure: (or 'az account show' to check if logged in)**
az login

**Deploy resource group:**
```bash
az group create --name "rg-logic-apps-workshop" --location "UK South"
```

**Deploy first storage account:**
```bash
az deployment group create --resource-group "rg-logic-apps-workshop" --template-file "target-storage.bicep"
```

**Deploy second storage account:**
```bash
az deployment group create --resource-group "rg-logic-apps-workshop" --template-file "destination-storage.bicep"
```

**Deploy Logic App (Consumption):**
```bash
az deployment group create --resource-group "rg-logic-apps-workshop" --template-file "ladctest001.bicep" --parameters workflowName="ladctest001"
```

