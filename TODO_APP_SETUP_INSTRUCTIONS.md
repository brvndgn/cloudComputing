# ToDo App Infrastructure Setup Instructions

## Overview
This document outlines the complete setup process for the ToDo application on Azure PaaS. The infrastructure has been partially automated using Bicep templates, but some manual configuration steps are still required.

## Automated Infrastructure (via Bicep)
The following Azure resources are automatically created by the Bicep templates:

### ✅ Resource Group
- **Name**: `RG-<identifier>-Tose1` (e.g., `RG-BDO-Tose1`)
- **Location**: Poland Central
- **Purpose**: Contains all ToDo app resources

### ✅ Storage Account
- **Name**: `stor<identifier>tose1` (e.g., `storbdotose1`)
- **Type**: StorageV2 with Standard_LRS
- **Features**:
  - HTTPS traffic only
  - Minimum TLS 1.2
  - Blob anonymous access enabled
- **Purpose**: Hosts the static web UI content

### ✅ Blob Container
- **Name**: `staticcontent`
- **Access Level**: Container (anonymous read access)
- **Purpose**: Stores the web application files (HTML, CSS, JS)

### ✅ Azure Function App
- **Name**: `fap-<identifier>-tose1` (e.g., `fap-bdo-tose1`)
- **Runtime**: .NET 8 (Isolated)
- **Hosting Plan**: Consumption (serverless)
- **Features**:
  - Connected to storage account
  - HTTPS enabled
  - FTP access allowed
- **Purpose**: Backend API for ToDo operations

### ✅ Cosmos DB Account
- **Name**: `cos-<identifier>-tose1` (e.g., `cos-bdo-tose1`)
- **Type**: NoSQL
- **Workload**: Learning (free tier enabled)
- **Features**:
  - Session consistency
  - Partition merge enabled
  - Public network access (all networks)
- **Purpose**: NoSQL database for ToDo items

### ✅ Cosmos DB Container
- **Database**: `ServerlessTodo`
- **Container**: `TodoItems`
- **Partition Key**: `/ItemOwner`
- **Features**: Compatible with older Cosmos .NET SDK versions
- **Purpose**: Stores ToDo items with partitioning by owner

## Manual Configuration Steps Required

### 1. Upload Web UI Content (~5 minutes)
**Location**: Azure Storage Explorer or Azure Portal
**Action**:
- Download the source code from: https://github.com/OliCSADoerr/ServerlessToDo
- Extract the `ui` folder
- Upload the entire `ui` folder to the `staticcontent` blob container
- Note the URL of the uploaded `index.html` file (needed for CORS configuration)

### 2. Configure Function App Environment Variable (~5 minutes)
**Location**: Azure Portal → Function App → Settings → Environment variables
**Action**:
- Add new environment variable:
  - **Name**: `CosmosDBConnectionString`
  - **Value**: Copy from Cosmos DB → Settings → Keys → Primary Connection String
- Click "Apply" to save changes

### 3. Configure CORS on Function App (~3 minutes)
**Location**: Azure Portal → Function App → CORS
**Action**:
- Add allowed origin: The base URL of your storage account (from step 1, excluding the file path)
- Example: `https://storbdotose1.blob.core.windows.net`
- Click "Save"

### 4. Deploy Application Code (~20 minutes)
**Location**: Visual Studio on local machine
**Action**:
- Open `TodoServerless.sln` from the downloaded source code
- Right-click the "api" project → Publish
- Select "Azure Function App (Windows)"
- Choose your created Function App (`fap-<identifier>-tose1`)
- Publish the application
- If prompted for credentials, select "Attempt to retrieve credentials from Azure"

### 5. Update JavaScript Configuration (~5 minutes)
**Location**: Azure Portal → Storage Account → Containers → staticcontent → ui/js/vars.js
**Action**:
- Open the `vars.js` file for editing
- Replace `<YOUR_FUNCTIONS_URL>` with your Function App's default domain
- Example: `var remoteUrl = "https://fap-bdo-tose1.azurewebsites.net/api/todoitem";`
- Save the changes

### 6. Test the Application (~3 minutes)
**Location**: Web browser
**Action**:
- Navigate to the `index.html` URL from step 1
- Test creating, reading, and deleting ToDo items
- Verify the full functionality works

## Deployment Commands

### Automated Deployment
```powershell
# Navigate to scripts folder
cd scripts

# Deploy all infrastructure
.\createResources.ps1
```

### Cleanup
```powershell
# Remove all resources
.\deleteResources.ps1
```

## Configuration Parameters

All parameters are defined in `parameters/main.parameters.json`:

```json
{
  "rgNamePoland": "RG-<identifier>-Tose1",
  "storageNamePoland": "stor<identifier>tose1",
  "functionAppName": "fap-<identifier>-tose1",
  "cosmosDbAccountName": "cos-<identifier>-tose1",
  "containerNamePoland": "staticcontent",
  "locationPoland": "polandcentral"
}
```

Replace `<identifier>` with your 3-digit identifier (e.g., "bdo").

## Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐
│   Web Browser   │────│  Storage Account │
│                 │    │  (Static UI)    │
└─────────────────┘    └─────────────────┘
         │                       │
         │                       │
         ▼                       ▼
┌─────────────────┐    ┌─────────────────┐
│ Function App    │────│   Cosmos DB     │
│ (.NET 8 API)    │    │   (NoSQL)       │
└─────────────────┘    └─────────────────┘
```

## Security Considerations

- HTTPS is enforced on all services
- Minimum TLS 1.2 required
- Function App has FTP access (consider restricting in production)
- Cosmos DB allows public access (configure VNet integration for production)

## Monitoring and Troubleshooting

- Check Function App logs in Azure Portal
- Monitor Cosmos DB metrics and request units
- Verify CORS settings if web app can't connect to API
- Check environment variables in Function App settings

## Next Steps for Production

1. Implement authentication (Azure AD, JWT tokens)
2. Configure VNet integration for security
3. Set up Application Insights monitoring
4. Configure backup policies for Cosmos DB
5. Implement CI/CD pipeline for code deployment
6. Add API versioning and rate limiting