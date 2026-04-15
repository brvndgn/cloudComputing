# Load parameters
Write-Host "Get parameters from 'parameters/main.parameters.json'..."
$params = Get-Content "../cloudComputing/parameters/main.parameters.json" | ConvertFrom-Json

# Login
Write-Host "Login to Azure with Azure CLI..."
az login

# Set subscription
Write-Host "Set subscription '$($params.parameters.subscriptionName.value)'..."
az account set --subscription $params.parameters.subscriptionId.value

# Ensure required providers are registered
$providers = @($params.parameters.providers.value + @('Microsoft.Resources')) | Select-Object -Unique
foreach ($provider in $providers) {
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
    $templateFile = "../main.bicep"
    $parametersFile = "@../parameters/main.parameters.json"
    
    & az deployment sub create --location $location --template-file $templateFile --parameters $parametersFile | Out-Null
    
    Write-Host "Bicep deployment completed successfully" -foregroundcolor green
}
catch {
    Write-Host "Error occurred during Bicep deployment" -foregroundcolor red
    exit 1
}