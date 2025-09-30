# Logic Apps Workshop 01

This workshop shows how to use Azure Logic Apps to transform and transfer files from Azure Storage Accounts. It also includes optional elements to understand the power of Infrasctructure as Code, CICD and Azure AI Foundry for modernising legacy workflows.

- Create a resource group in Azure called "rg-logic-apps-workshop". 
- Install Azure CLI. 
- Using Bash (for Mac) / PowerShell (for Windows) in the terminal run the commands below to create two storage accounts and logic app(s). 
- Use Azure extension in VS Code to deploy the Logic App Workflow JSON to the Logic App. 
- Update the Logic apps connectors. 
- Add a new file to the first storage account and see it trigger the Logic app. 
- Optional extension: Create a Logic Apps Standard Plan in Azure portal and link to GitHUb for CICD (then change the JSON in workflow and commit to GitHub to deploy)
- Optional extension: Create a Azure AI Foundry Endpoint and an extra step in the workflow to rename the file based on its contents using the prompt below

## Install Azure CLI from terminal:  
Windows: winget install --exact --id Microsoft.AzureCLI (then restart terminal)  
Mac: brew update && brew install azure-cli

Windows:
https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?view=azure-cli-latest&pivots=winget

Mac:
https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-macos?view=azure-cli-latest

### 🌐 Public Storage (Default)
**File:** `simple-storage.bicep` (15 lines)
- Public network access enabled
- Accessible from anywhere

**Using Terminal, Login to Azure: (or 'az account show' to check if logged in)**
az login


**Deploy:**
```bash
az group create --name "rg-logic-apps-workshop" --location "UK South"
az deployment group create --resource-group "rg-logic-apps-workshop" --template-file "simple-storage.bicep" --parameters storageAccountName="mystorageacct$(date +%s)"
```

### 🔒 Private Storage 
**File:** `private-storage.bicep` (16 lines)
- Public network access disabled
- Only accessible via private endpoints or trusted Azure services

**Deploy:**
```bash
az group create --name "rg-workshop" --location "UK South"
az deployment group create --resource-group "rg-logic-apps-workshop" --template-file "private-storage.bicep" --parameters storageAccountName="myprivatestg$(date +%s)"
```

Both create **General Purpose v2** accounts with Blob, File, Queue, and Table storage. ✨

### ⚡ Logic App (Consumption Plan)
**File:** `simple-logicapp.bicep` (17 lines)
- Consumption-based pricing (pay-per-execution)
- Empty workflow ready for customization

**Deploy:**
```bash
az deployment group create --resource-group "rg-logic-apps-workshop" --template-file "simple-logicapp.bicep" --parameters logicAppName="mylogicapp$(date +%s)"
```

### Prompt to rename file using Azure OpenAI
"Create a three word string that summarises the contents of this file". 