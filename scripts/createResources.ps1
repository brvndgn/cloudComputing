# Load parameters
Write-Host "Get parameters from 'parameters/main.parameters.json'..."
$params = Get-Content "parameters/main.parameters.json" | ConvertFrom-Json

# Set script-level variables
$subscriptionName = "Azure for Students"
$subscriptionId = "31b4c445-3541-456c-a8ec-f7c00f279dcb"
$providers = @("Microsoft.Storage")

# Login
Write-Host "Login to Azure with Azure CLI..."
az login

# Set subscription
Write-Host "Set subscription '$subscriptionName'..."
az account set --subscription $subscriptionId

# Ensure required providers are registered
$providersList = @($providers + @('Microsoft.Resources')) | Select-Object -Unique
foreach ($provider in $providersList) {
    $state = az provider show --namespace $provider --query registrationState -o tsv
    if ($state -ne "Registered") {
        Write-Host "Registering provider $provider..." -foregroundcolor yellow
        az provider register --namespace $provider

        while ($true) {
            $state = az provider show --namespace $provider --query registrationState -o tsv
            Write-Host "Current state: $state"
            if ($state -eq "Registered") {
                Write-Host "$provider successfully registered" -foregroundcolor green
                break
            }
            Start-Sleep -Seconds 5
        }
    }
    else {
        Write-Host "$provider is already registered" -foregroundcolor green
    }
}

# Deploy Bicep template at subscription scope
Write-Host "Deploying Bicep template 'main.bicep' at subscription scope..."
try {
    $location = $params.parameters.location.value
    $templateFile = "main.bicep"
    $parametersFile = "@parameters/main.parameters.json"
    
    & az deployment sub create --location $location --template-file $templateFile --parameters $parametersFile | Out-Null
    
    Write-Host "Bicep deployment completed successfully" -foregroundcolor green
}
catch {
    Write-Host "Error occurred during Bicep deployment" -foregroundcolor red
    exit 1
}