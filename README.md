# Cloud Computing Course

Infrastruktur as Code Cloud Computing Course at FHNW

# HandOn Assesment Setup as IaC (Cloud Computing)

With help of the templates and scripts inside this repo, the whole handson Assesment of the Cloud Computing Course at FHNW can be deployed, stopped or deleted.

## Setup Instructions

### 1. Download and install Visual Studio Code (VSCode)

- https://code.visualstudio.com/download
- Install Powershell Extension inside VSCode
- Install Git Extension inside VSCode
- Install Bicep Extension inside VSCode

### 2. Configure Git
```bash
# Start Terminal and setup Username and Mail inside Git Config
git config --global user.name "FIRST_NAME LAST_NAME"
git config --global user.email "MY_NAME@example.com"

# Check if your config is visible
cat .git/config
```

### 3. Install Azure CLI
https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install?tabs=azure-powershell#azure-cli

```bash
# For Mac User: Start Terminal and un this following command
brew update && brew install azure-cli
```

### 4. Install Bicep
https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install?tabs=azure-powershell

```bash
# For Mac User: Start Terminal and run the following command
sudo rm -rf /Library/Developer/CommandLineTools
sudo xcode-select --install
brew update && brew install bicep
```