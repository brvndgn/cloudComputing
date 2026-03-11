# Load parameters
Write-Host "Get Parameter from 'params.json'..." 
$params = Get-Content "params.json" | ConvertFrom-Json

# Login
Write-Host "Login to Azure with azure cli..."
az login

# Set subscription
Write-Host "Set subscription '$($params.subscriptionName)'..."
az account set --subscription $params.subscriptionId

$rgExists = az group exists --name $($params.rgName)

if ($rgExists -eq "true") {

    Write-Host "Deleting resource group $($params.rgName)..."

    try {
        az group delete `
          --name $($params.rgName) `
          --yes `
          --no-wait
          
        Write-Host "Resource group '$($params.rgName)' deletion initiated successfully" -foregroundcolor green
    } catch {
        Write-Host "Error occurred while deleting resource group '$($params.rgName)'" -foregroundcolor red
    }
}else {
    Write-Host "Resource group $($params.rgName) does not exist."
}