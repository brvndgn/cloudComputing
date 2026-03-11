# Load parameters
$params = Get-Content "./parameters.json" | ConvertFrom-Json

# Login
az login

# Set subscription
az account set --subscription $params.subscription

# Create resource group
az group create `
  --name $params.resourceGroupName `
  --location $params.location

# Create storage account
az storage account create `
  --name $params.storageAccountName `
  --resource-group $params.resourceGroupName `
  --location $params.location `
  --sku $params.storageSku `
  --kind StorageV2