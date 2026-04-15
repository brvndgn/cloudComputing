# Load parameters
Write-Host "Get parameters from 'parameters/main.parameters.json'..."
$params = Get-Content "../cloudComputing/parameters/main.parameters.json" | ConvertFrom-Json

# Login
Write-Host "Login to Azure with Azure CLI..."
az login

# Set subscription
Write-Host "Set subscription '$($params.parameters.subscriptionName.value)'..."
az account set --subscription $params.parameters.subscriptionId.value

# Delete resource group RG-BDO-CLI if it exists

$rgName = $params.parameters.rgName.value
$rgExists = az group exists --name $rgName

if ($rgExists -eq "true") {

    Write-Host "Deleting resource group $rgName..."

    try {
        az group delete `
            --name $rgName `
            --yes `
            --no-wait
        Write-Host "Resource group '$rgName' deletion initiated successfully" -foregroundcolor green
    }
    catch {
        Write-Host "Error occurred while deleting resource group '$rgName'" -foregroundcolor red
    }
}else{
    Write-Host "Resource group $rgName does not exist."
}

# Delete resource group RG-BDO-Tose1 if it exists

$rgName = $params.parameters.rgNamePoland.value
$rgExists = az group exists --name $rgName

if ($rgExists -eq "true") {

    Write-Host "Deleting resource group $rgName..."

    try {
        az group delete `
            --name $rgName `
            --yes `
            --no-wait
        Write-Host "Resource group '$rgName' deletion initiated successfully" -foregroundcolor green
    }
    catch {
        Write-Host "Error occurred while deleting resource group '$rgName'" -foregroundcolor red
    }
}else{
    Write-Host "Resource group $rgName does not exist."
}