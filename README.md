# Cloud Computing Course

Cloud Computing Course at FHNW

# HandOn Assesment Setup as IaC (Cloud Computing)

With help of the templates and scripts inside this repo, the whole handson Assesment of the Cloud Computing Course at FHNW can be deployed, stopped or deleted.

## Setup Instructions

### 1. Download and install Visual Studio Code (VSCode) + Extensions

- https://code.visualstudio.com/download
- Install Powershell Extension inside VSCode
- Install Git Extension inside VSCode

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

### 4. How to run

Download the *.json and *.params files or clone it from git

Open a Termina or VSCode and navigate to the folder where the downloaded scripts are located
```bash
cd /Path/ToScripts/
```

To create all resources run:
```bash
./createResources.ps1
```

To delete all resources run:
```bash
./deleteResources.ps1
```

Login with you FHNW Account