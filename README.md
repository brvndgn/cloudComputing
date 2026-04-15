# Cloud Computing Course - IaC Setup

Cloud Computing Course at FHNW - Infrastructure as Code (IaC) Assessment Setup

## What This Project Does

This repository contains **Infrastructure as Code (IaC)** templates that automatically create and manage Azure cloud resources for the Cloud Computing course assessment. Instead of manually creating resources through the Azure portal, you can deploy everything with a single command.

### What Gets Created:
- **Resource Groups** in different Azure regions
- **Storage Accounts** with security configurations
- **Blob Containers** with public access settings

### Technologies Used:
- **Bicep**: Microsoft's domain-specific language (DSL) for deploying Azure resources
- **Azure CLI**: Command-line tool for managing Azure resources
- **PowerShell**: Scripting language for automation
- **Git**: Version control for code management

---

## Setup Instructions (Step-by-Step)

### Step 1: Install Visual Studio Code (VSCode)

**Why?** VSCode is a free, powerful code editor that supports Bicep, PowerShell, and Azure development.

1. **Download VSCode:**
   - Go to: https://code.visualstudio.com/download
   - Download the version for your operating system (Windows/Mac/Linux)
   - Install it following the setup wizard

2. **Install Required Extensions:**
   - Open VSCode
   - Click the Extensions icon (square icon on the left sidebar) or press `Ctrl+Shift+X` (`Cmd+Shift+X` on Mac)
   - Search for and install these extensions:
     - **PowerShell** (by Microsoft) - For running PowerShell scripts
     - **Git Extension Pack** (by Don Jayamanne) - For Git integration
     - **Bicep** (by Microsoft) - For Bicep language support and IntelliSense

3. **Verify Installation:**
   - Restart VSCode
   - You should see PowerShell and Bicep syntax highlighting
   - Extensions should appear in the left sidebar

### Step 2: Configure Git

**Why?** Git is used for version control and to download this project repository.

1. **Install Git (if not already installed):**
   - **Windows:** Download from https://git-scm.com/download/win
   - **Mac:** Git comes pre-installed, or install with `brew install git`
   - **Linux:** Use your package manager (e.g., `sudo apt install git`)

2. **Configure Git with your information:**
   ```bash
   # Open Terminal/Command Prompt and run:
   git config --global user.name "Your Full Name"
   git config --global user.email "your.email@domain.com"
   ```

3. **Verify Git configuration:**
   ```bash
   # Check your settings:
   git config --global user.name
   git config --global user.email
   ```

   You should see your name and email displayed.

### Step 3: Install Azure CLI

**Why?** Azure CLI is the command-line tool that communicates with Azure to create and manage resources.

1. **Install Azure CLI:**
   - **Windows:** Download from https://aka.ms/installazurecliwindows
   - **Mac:** Run this command in Terminal:
     ```bash
     brew update && brew install azure-cli
     ```
   - **Linux:** Follow instructions at https://docs.microsoft.com/en-us/cli/azure/install-azure-cli

2. **Verify Installation:**
   ```bash
   # Check if Azure CLI is installed:
   az --version
   ```

   You should see version information displayed.

3. **Login to Azure:**
   ```bash
   # Login to your Azure account:
   az login
   ```

   This will open a browser window for you to authenticate with your Azure account (use your FHNW credentials).

4. **Install Bicep CLI (required for Bicep templates):**
   ```bash
   # Install Bicep CLI:
   az bicep install
   ```

   **Verify Bicep installation:**
   ```bash
   # Check Bicep version:
   az bicep version
   ```

### Step 4: Download and Run the Project

**Why?** This section explains how to get the project files and execute the deployment.

#### 4.1 Get the Project Files

**Option A: Clone with Git (Recommended)**
```bash
# Navigate to where you want to store the project:
cd ~/Desktop  # or any folder you prefer

# Clone the repository:
git clone <repository-url>
cd cloudComputing
```

**Option B: Download ZIP**
- Download the project as a ZIP file from the repository
- Extract it to a folder on your computer
- Open the extracted folder in VSCode

#### 4.2 Understand the Project Structure

Before running, let's understand what each file does:

```
cloudComputing/
├── main.bicep                    # Main template (entry point)
├── main.json                     # Compiled ARM template (auto-generated)
├── modules/
│   ├── storageAccount.bicep      # Storage account module
│   └── blobStorageAccount.bicep  # Blob storage with public access
├── parameters/
│   └── main.parameters.json      # ALL configuration values
├── scripts/
│   ├── createResources.ps1       # DEPLOYMENT script
│   └── deleteResources.ps1       # CLEANUP script
└── README.md                     # This file
```

#### 4.3 Configure Your Deployment

**Important:** Before running, you need to customize the parameters file:

1. Open `parameters/main.parameters.json` in VSCode
2. Update the values to match your needs:
   - `subscriptionId`: Your Azure subscription ID
   - `rgName`: Resource group name for Switzerland North
   - `storageName`: Storage account name for Switzerland North
   - `rgNamePoland`: Resource group name for Poland Central
   - `storageNamePoland`: Storage account name for Poland Central

**Example configuration:**
```json
{
  "subscriptionId": { "value": "your-subscription-id-here" },
  "rgName": { "value": "RG-MyProject-Switzerland" },
  "storageName": { "value": "stmyprojectswiss" },
  "rgNamePoland": { "value": "RG-MyProject-Poland" },
  "storageNamePoland": { "value": "stmyprojectpoland" }
}
```

#### 4.4 Run the Deployment

1. **Open PowerShell Terminal in VSCode:**
   - In VSCode: View → Terminal
   - Make sure PowerShell is selected (not Command Prompt or bash)

2. **Navigate to the scripts folder:**
   ```powershell
   # Change to the scripts directory:
   cd scripts
   ```

3. **Run the deployment:**
   ```powershell
   # Execute the deployment script:
   .\createResources.ps1
   ```

4. **What happens during deployment:**
   - Script loads parameters from `../parameters/main.parameters.json`
   - Logs into Azure (if not already logged in)
   - Registers required Azure providers
   - Creates resource groups in Switzerland North and Poland Central
   - Creates storage accounts with appropriate configurations
   - Creates a public blob container in Poland Central

5. **Monitor the deployment:**
   - The script will show progress messages
   - Deployment typically takes 2-5 minutes
   - You'll see "Bicep deployment completed successfully" when done

#### 4.5 Verify Deployment

After successful deployment, verify resources were created:

```bash
# List resource groups:
az group list --output table

# List storage accounts:
az storage account list --output table
```

#### 4.6 Cleanup (When Done)

To delete all created resources:

```powershell
# In the scripts folder:
.\deleteResources.ps1
```

---

## Troubleshooting

### Common Issues:

**"az command not found"**
- Azure CLI is not installed or not in PATH
- Reinstall Azure CLI and restart your terminal

**"Bicep CLI not installed"**
```bash
az bicep install
```

**"Login required"**
```bash
az login
```

**"Permission denied" or "Authorization failed"**
- Make sure you're using your FHNW Azure account
- Check that your subscription ID in parameters is correct

**PowerShell script won't run**
- In PowerShell: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
- Make sure you're in the correct directory (`scripts` folder)

**"Resource group already exists"**
- Change the resource group names in `main.parameters.json`
- Or delete existing resource groups first

### Need Help?
- Check the Azure CLI documentation: https://docs.microsoft.com/en-us/cli/azure/
- Bicep documentation: https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/
- Ask your instructor or check course materials

---

## What You Learned

By completing this setup, you learned:
- Infrastructure as Code (IaC) concepts
- Azure Resource Manager and Bicep templates
- Modular template design
- Parameter management and configuration
- Azure CLI for resource management
- PowerShell scripting for automation

## Project Structure

```
cloudComputing/
├── main.bicep                    # Main subscription-scoped template
├── main.json                     # Auto-generated ARM template
├── modules/
│   ├── storageAccount.bicep      # General storage account module
│   └── blobStorageAccount.bicep  # Blob storage with anonymous access module
├── parameters/
│   └── main.parameters.json      # Parameter values for deployments
├── scripts/
│   ├── createResources.ps1       # Deployment script
│   └── deleteResources.ps1       # Cleanup script
└── README.md                     # This documentation
```

## Parameter Management

This project follows **complete parameter consolidation** - all parameter values come from the JSON file only:

### **Single Source of Truth**
- **Parameter definitions** are only in `main.bicep` (no defaults)
- **Parameter values** are only in `parameters/main.parameters.json`
- **Modules** receive parameters but don't define defaults

### **Why This Approach?**
- ✅ **Zero duplication** - Parameters defined exactly once
- ✅ **Complete externalization** - All values in parameter files
- ✅ **Environment flexibility** - Different parameter files for dev/staging/prod
- ✅ **Template purity** - Bicep files contain only logic, no hardcoded values

### **Parameter Flow:**
```
parameters/main.parameters.json → main.bicep → modules/ → Azure Resources
       (ALL values)              (declarations) (logic)     (deployment)
```

### Bicep Files
- **`main.bicep`** - Main subscription-scoped template that creates the resource groups and orchestrates deployments
- **`modules/storageAccount.bicep`** - Resource-group-scoped module that creates a general storage account with security settings
- **`modules/blobStorageAccount.bicep`** - Resource-group-scoped module that creates a blob storage account with anonymous access and a public container

### JSON Files
You have two JSON files that serve different purposes in the Azure Resource Manager deployment process:

##### `parameters/main.parameters.json` - Parameter Values (Required)
This file contains the actual values for your deployment parameters. It's what you edit to customize your deployment:
```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "rgName": { "value": "RG-LBA-CLI" },
        "storageName": { "value": "storlbaportal" },
        "location": { "value": "switzerlandnorth" }
    }
}
```
**Why you need this:** It provides the specific values (like resource names, locations) that get injected into your template during deployment.

#### `main.json` - Compiled ARM Template (Auto-generated)
This is the actual ARM template that Azure deploys. It gets automatically generated from your `main.bicep` file when you run `az bicep build`:
```json
{
  "$schema": "https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#",
  "parameters": {
    "rgName": { "type": "string" },
    "storageName": { "type": "string" }
  },
  "resources": [ /* actual resource definitions */ ]
}
```
**Why it exists:** Azure Resource Manager only understands JSON templates, not Bicep. So Bicep compiles your `.bicep` file into this JSON format for deployment.

**The Workflow:**
1. **You edit** `main.bicep` (human-readable Bicep code)
2. **Bicep compiles** it to `main.json` (ARM template JSON) 
3. **Azure deploys** using `main.json` + values from `parameters/main.parameters.json`

**Can you delete one?**
- ❌ **Don't delete `parameters/main.parameters.json`** - Your deployment needs these values
- ✅ **You can delete `main.json`** - It gets regenerated automatically when you deploy or run `az bicep build`

To delete all resources run:
```bash
./deleteResources.ps1
```

Login with you FHNW Account