# Scenario 04 – Zero Trust Private Application Architecture (Hub–Spoke + Firewall + Private Endpoints)

## 🎯 Objective
Design and deploy a fully private, Zero Trust application environment using Azure Firewall, Private Endpoints, Private DNS Zones, and a Hub–Spoke network topology.  
The environment must ensure that **no resource is exposed to the public Internet**, while still enabling secure communication between application, data, and platform services.

### **This scenario demonstrates:**
- Zero Trust network segmentation  
- Forced tunneling through Azure Firewall  
- Private-only access to PaaS services (SQL, Storage, Web App, Key Vault)  
- Private DNS resolution for all Private Endpoints  
- Hub–Spoke architecture with centralized security  
- Outbound traffic inspection and control  
- Secure VM access through private networking  

---

## Architecture Overview
This scenario builds a **fully isolated application environment** where all traffic flows through a secured Hub VNet containing Azure Firewall.  
The Spoke VNet hosts the application workloads and Private Endpoints, while all outbound traffic is forced through the firewall for inspection.

### **Key components:**
- Resource Group (rg-s04-zero-trust)
- Hub VNet (vnet-hub-s04) with Azure Firewall
- Spoke VNet (vnet-spoke-s04) with:
  - Application subnet  
  - Private Endpoint subnet  
- Azure Firewall + Firewall Policy
- Route Table enforcing forced tunneling
- Virtual Machine (vm-test-s04)
- App Service Plan + Web App (webapp-s04)
- SQL Server + SQL Database (db-s04)
- Storage Account (stors04)
- Key Vault (kv-s04)
- Private Endpoints for SQL, Storage, Web App
- Private DNS Zones for all PaaS services

---

## Azure Services Used
- Virtual Network (Hub + Spoke)
- Subnets (App, Private Endpoint, Firewall)
- Azure Firewall + Firewall Policy
- Route Table (forced tunneling)
- Network Security Group
- Virtual Machine
- App Service Plan + Web App
- SQL Server + SQL Database
- Storage Account
- Key Vault
- Private Endpoints
- Private DNS Zones + VNet Links

---

## Network Design

### **Hub VNet**
- Address space: 10.40.0.0/16  
- Subnet: AzureFirewallSubnet (10.40.1.0/24)

### **Spoke VNet**
- Address space: 10.45.0.0/16  
- Subnets:
  - subnet-app (10.45.1.0/24)
  - subnet-app-wapp (10.45.0.0/24)
  - subnet-pe-webapp (10.45.2.0/24)

### **Routing**
- Route Table: rt-spoke-s04  
- Default route:  
  - `0.0.0.0/0 → Azure Firewall (10.40.1.4)`  
- Applied to:
  - subnet-app  
  - subnet-pe-webapp  

### **Security**
- No public endpoints on PaaS services  
- All outbound traffic inspected by Azure Firewall  
- NSG on VM subnet allows only internal traffic  
- Key Vault network ACL: Deny by default  

This ensures **complete isolation** from the public Internet.

---

## Compute Layer
- VM Name: vm-test-s04  
- OS: Ubuntu 22.04 LTS  
- Size: Standard B2s  
- Public IP: Optional (for testing only)  
- NSG: Allows SSH only if explicitly required  
- VM used for:
  - Testing Private Endpoints  
  - Testing DNS resolution  
  - Testing forced tunneling  

---

## Application Layer
- App Service Plan: ASP-rgs04zerotrust-96a9  
- Web App: webapp-s04  
- Public access: Disabled  
- Access: Only via Private Endpoint  
- DNS: privatelink.azurewebsites.net  

---

## Data Layer
### **SQL Server**
- Name: sql-s04-server  
- Region: North Europe  
- Public Network Access: Disabled  
- Private Endpoint: Enabled  

### **SQL Database**
- Name: db-s04  
- SKU: Basic  

### **Storage Account**
- Name: stors04  
- TLS 1.2 enforced  
- Public access disabled  
- Private Endpoint: Enabled  

### **Key Vault**
- Name: kv-s04  
- Public access disabled  
- Private Endpoint: Enabled  

---

## Private Connectivity

### **Private Endpoints**
- pe-sql-s04 → SQL Server  
- pe-stors04-blob → Storage Account (Blob)  
- subnet-pe-webapp → Web App  

### **Private DNS Zones**
- privatelink.database.windows.net  
- privatelink.blob.core.windows.net  
- privatelink.azurewebsites.net  
- privatelink.vaultcore.azure.net  

Each zone is linked to the Spoke VNet.

---

## Firewall Layer
- Azure Firewall: afw-hub-s04  
- Public IP: pip-afw-hub-s04  
- Firewall Policy: afw-policy-s04  
- Threat Intel Mode: Alert  
- No outbound allow rules (Zero Trust)  

All outbound traffic is blocked unless explicitly allowed.

---

## Security Considerations
- No public endpoints for SQL, Storage, Web App, or Key Vault  
- Forced tunneling ensures all outbound traffic is inspected  
- Private DNS prevents DNS leakage  
- Hub–Spoke segmentation isolates workloads  
- NSG restricts VM access  
- Key Vault locked down with network ACLs  
- Firewall Policy enforces Zero Trust  

---

## Testing

### **1. Test Private DNS**
From vm-test-s04:

```bash
nslookup webapp-s04.privatelink.azurewebsites.net
nslookup sql-s04-server.privatelink.database.windows.net
```

Expected:  
Private IPs from 10.45.x.x range.

---

### **2. Test Private Endpoints**
```bash
curl https://webapp-s04.azurewebsites.net
```

Expected:  
Response from Web App via Private Endpoint.

---

### **3. Test SQL Connectivity**
```bash
sqlcmd -S sql-s04-server.privatelink.database.windows.net -U sqladminuser -P <password>
```

Expected:  
Successful login.

---

### **4. Test Forced Tunneling**
```bash
curl https://www.microsoft.com
```

Expected:  
Connection blocked (Firewall denies outbound).

---

## Lessons Learned
- Private Endpoints eliminate the need for public exposure of PaaS services  
- Azure Firewall provides centralized outbound control  
- Private DNS Zones are essential for Private Endpoint resolution  
- Hub–Spoke architecture simplifies security boundaries  
- Zero Trust requires explicit allow rules — everything else is denied  
- Forced tunneling ensures all outbound traffic is inspected  
- Network segmentation drastically reduces attack surface  

