# cloudComputing

Infrastruktur as Code Cloud Computing Course at FHNW

# Parking Payment Application

With help of the templates and scripts inside this repo, the whole handson Assesment of the Cloud Computing Course at FHNW can be deployed, stopped or deleted.

## Setup Instructions

### 1. Download and install Visual Studio Code (VSCode)

- https://code.visualstudio.com/download
- Install Powershell Extension inside VSCode
- Install Git Extension inside VSCode
- Install Bicep Extension inside VSCode

### 4. Install Azure CLI
- https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install?tabs=azure-powershell#azure-cli

```bash
# For Mac User: Start Terminal and un this following command
brew update && brew install azure-cli
```

### 3. Install Bicep
- https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install?tabs=azure-powershell

```bash
# For Mac User: Start Terminal and run the following command
sudo rm -rf /Library/Developer/CommandLineTools
sudo xcode-select --install
brew update && brew install bicep
```