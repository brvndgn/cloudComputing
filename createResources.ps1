# Load parameters
Write-Host "Get Parameter from 'params.json'..." 
$params = Get-Content "params.json" | ConvertFrom-Json

# Login
Write-Host "Login to Azure with azure cli..."
az login

# Set subscription
Write-Host "Set subscription '$($params.subscriptionName)'..."
az account set --subscription $params.subscriptionId

# Ensure Storage provider is registered
foreach($provider in $params.providers) {
    $state = az provider show --namespace $provider --query registrationState -o tsv
    if ($state -ne "Registered") {
        Write-Host "Registering provider $provider..." -foregroundcolor yellow
        az provider register --namespace Microsoft.Storage

        # Wait until provider is registered
        while ($true) {
            $state = az provider show --namespace $provider --query registrationState -o tsv
            Write-Host "Current state: $state" 
            if ($state -eq "Registered") {
                Write-Host "$provider successfully registered" -foregroundcolor green
                break
            }
            Start-Sleep -Seconds 5
        }
    }else{
        Write-Host "$provider is already registered" -foregroundcolor green
    }
}

# Create resource group
$rgExists = az group exists --name $($params.rgName)
if($rgExists -eq "false") {
    Write-Host "Creating resource group '$($params.rgName)' in location '$($params.location)'..."
    try {
        az group create `
            --name $params.rgName `
            --location $params.location

        Write-Host "resource group '$($params.rgName)' created successfully" -foregroundcolor green
    } catch {
        Write-Host "Error occurred while creating resource group '$($params.rgName)'" -foregroundcolor red
    }
}else{
    Write-Host "Resource group '$($params.rgName)' already exists" -foregroundcolor green
}

# Create storage account
$storageExists = az storage account show `
    --name $($params.storageName) `
    --resource-group $($params.rgName) `
    --query name -o tsv 2>$null

if(!$storageExists) {
    Write-Host "Creating storage account '$($params.storageName)' in resource group '$($params.rgName)'..."
    try{
        az storage account create `
        --name $($params.storageName) `
        --resource-group $($params.rgName) `
        --location $($params.location) `
        --sku $($params.storageSku) `
        --kind $($params.storageKind) `
        --min-tls-version $($params.storageMinTlsVersion)
    Write-Host "Storage account '$($params.storageName)' created successfully" -foregroundcolor green
    } catch {
        Write-Host "Error occurred while creating storage account '$($params.storageName)'" -foregroundcolor red
    }
}else{
    Write-Host "Storage account '$($params.storageName)' already exists" -foregroundcolor green
}