# Scenario 06 – End‑to‑End Zero Trust Project with Centralized Monitoring

## **Objective**
This scenario demonstrates how to build a lightweight but fully secure Zero Trust environment in Azure. The goal is to deploy a complete project that includes:

- Isolated virtual network with segmented subnets  
- Private‑only data services (SQL, Storage, Key Vault)  
- Private Endpoints and Private DNS Zones  
- A compute layer (VM or App Service)  
- Managed Identity for secretless authentication  
- Centralized monitoring using Log Analytics Workspace  
- Diagnostic settings, alert rules, and a security workbook  

The entire environment is designed to run with minimal cost while still showcasing enterprise‑grade security patterns.

---

## **Architecture Overview**

- **Resource Groups:**  
  - `rg-core` → networking, compute, data  
  - `rg-s06-monitoring` → Log Analytics, alerts, workbooks  

- **Virtual Network:** `vnet-core`  
  - `app-subnet` → VM or App Service integration  
  - `data-subnet` → Private Endpoints  

- **Data Layer:**  
  - Azure SQL Database (Basic tier, private access only)  
  - Azure Storage Account (private access only)  
  - Azure Key Vault (private access only)  

- **Connectivity:**  
  - Private Endpoints for SQL, Storage, and Key Vault  
  - Private DNS Zones for name resolution  

- **Identity:**  
  - User Assigned Managed Identity for application access  

- **Monitoring:**  
  - Log Analytics Workspace  
  - Diagnostic settings for all services  
  - Alert rules for SQL, Key Vault, Storage, NSG  
  - Security observability workbook  

---

## **Azure Services Used**

- Azure Resource Groups  
- Azure Virtual Network + Subnets  
- Azure SQL Database  
- Azure Storage Account  
- Azure Key Vault  
- Private Endpoints  
- Private DNS Zones  
- Virtual Machine or App Service  
- Managed Identity  
- Log Analytics Workspace  
- Azure Monitor Alerts  
- Azure Workbooks  

---

## **Network Design**

- **VNet:** `10.60.0.0/16`  
- **Subnets:**  
  - `app-subnet` → `10.60.1.0/24`  
  - `data-subnet` → `10.60.2.0/24`  

The **app-subnet** hosts the application layer (VM or App Service).  
The **data-subnet** hosts all Private Endpoints, ensuring that SQL, Storage, and Key Vault remain isolated from the public internet.

---

## **Deployment Steps**

### **1. Resource Groups**
Two resource groups separate core infrastructure from monitoring:

```bash
az group create -n rg-core -l westeurope
az group create -n rg-s06-monitoring -l westeurope
```

---

### **2. Virtual Network and Subnets**

```bash
az network vnet create \
  -g rg-core \
  -n vnet-core \
  --address-prefixes 10.60.0.0/16 \
  --subnet-name app-subnet \
  --subnet-prefixes 10.60.1.0/24
```

```bash
az network vnet subnet create \
  -g rg-core \
  --vnet-name vnet-core \
  -n data-subnet \
  --address-prefixes 10.60.2.0/24
```

---

### **3. Log Analytics Workspace**

```bash
az monitor log-analytics workspace create \
  -g rg-s06-monitoring \
  -n law-core-monitoring \
  -l westeurope
```

---

### **4. SQL Database (Private‑Only)**

- Public network access disabled  
- Private Endpoint created in `data-subnet`  
- Connected to Private DNS zone  

---

### **5. Storage Account (Private‑Only)**

- Public access disabled  
- Blob endpoint exposed only via Private Endpoint  
- Private DNS zone for blob resolution  

---

### **6. Key Vault (Private‑Only)**

- Public network access disabled  
- RBAC enabled  
- Private Endpoint + Private DNS zone  

---

### **7. Private Endpoints and Private DNS**

Private Endpoints created for:

- SQL (`privatelink.database.windows.net`)  
- Storage Blob (`privatelink.blob.core.windows.net`)  
- Key Vault (`privatelink.vaultcore.azure.net`)  

Each endpoint is associated with a Private DNS zone and linked to `vnet-core`.

---

### **8. Application Layer (VM or App Service)**

A lightweight VM is recommended for testing:

- No public IP  
- NSG allowing only SSH from admin IP  
- Access to SQL, Storage, and Key Vault via Private Endpoints  
- Azure CLI installed for testing  

---

### **9. Managed Identity**

A User Assigned Managed Identity is created and granted:

- **Key Vault Secrets User** on the Key Vault  
- Database roles (`db_datareader`, `db_datawriter`) inside SQL  

The application uses this identity to authenticate without secrets.

---

### **10. Monitoring, Alerts, and Workbook**

Diagnostic settings send logs to `law-core-monitoring` for:

- SQL Server  
- Storage Account  
- Key Vault  
- NSG  
- VM (via Azure Monitor Agent)  

Alert rules detect:

- Key Vault forbidden operations  
- SQL failed logins  
- Storage blob deletions  
- NSG inbound denies  

A custom workbook visualizes:

- Key Vault audit events  
- SQL authentication failures  
- Storage delete operations  

---

## **Security Model**

- No public access to SQL, Storage, or Key Vault  
- All traffic flows through Private Endpoints  
- Private DNS ensures correct name resolution  
- Managed Identity eliminates secrets  
- NSG restricts inbound traffic to the VM  
- Centralized monitoring ensures visibility into all operations  

This architecture follows Zero Trust principles: **explicit verification, least privilege, and assume breach**.

---

## **Testing**

From the VM in `app-subnet`:

- `nslookup` to verify Private DNS resolution  
- `az keyvault secret show` to generate Key Vault audit logs  
- `sqlcmd` with wrong password to generate SQL failed logins  
- `az storage blob delete` to generate Storage delete logs  

All events should appear in the Log Analytics Workspace.

---

## **Lessons Learned**

- Private Endpoints and Private DNS are essential for secure, private-only services  
- Managed Identity simplifies authentication and removes secrets  
- Diagnostic settings and alerts provide visibility into security events  
- A small, cost‑efficient environment can still demonstrate full Zero Trust architecture  
- Separating monitoring resources improves governance and clarity  

