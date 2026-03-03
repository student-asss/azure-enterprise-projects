# Scenario 05 – Secure Data Platform with Private Endpoints

## **Objective**
The goal of this scenario is to design and deploy a secure data platform in Azure using:

- Azure SQL Database  
- Azure Storage Account  
- Azure Key Vault  
- Private Endpoints for all services  
- Private DNS Zones  
- Managed Identity for secure access  
- Governance and Azure Policies to enforce security  

This scenario builds on previous ones (Zero Trust, VMSS API) and demonstrates how to securely store and access data in Azure **without exposing any service to the public internet**.

---

## **Architecture Overview**

- **VNet:** `vnet-data` with `app-subnet` and `data-subnet`  
- **SQL Database:** Private Endpoint only, public access disabled  
- **Storage Account:** Private Endpoint only, public access disabled  
- **Key Vault:** Private Endpoint only, public access disabled  
- **Private DNS Zones:** For SQL, Storage, and Key Vault  
- **Managed Identity:** Used by the application to access Key Vault and SQL  
- **Governance:** Azure Policy enforcing private access and denying public exposure  

---

## **Azure Services Used**

- Azure SQL Database  
- Azure Storage Account  
- Azure Key Vault  
- Virtual Network + Subnets  
- Private Endpoints  
- Private DNS Zones  
- Managed Identity  
- Azure Policy  
- Log Analytics (optional)  

---

## **Network Design**

- **VNet:** `10.50.0.0/16`  
- **Subnets:**  
  - `app-subnet` → `10.50.1.0/24`  
  - `data-subnet` → `10.50.2.0/24`  

The **app-subnet** hosts the application (API, Functions, etc.).  
The **data-subnet** hosts the Private Endpoints for SQL, Storage, and Key Vault.

---

## **Security Model**

- No public access to SQL, Storage, or Key Vault  
- All access flows through Private Endpoints  
- Name resolution handled by Private DNS Zones  
- Application uses Managed Identity to access Key Vault and SQL  
- Azure Policy enforces:  
  - Deny public network access  
  - Deny public IPs  
  - Require resource tags  

---

## **Access Flow**

1. The application (API) in `app-subnet` uses its Managed Identity  
2. The Managed Identity retrieves secrets from Key Vault  
3. The SQL connection string is stored in Key Vault  
4. The application connects to SQL through the Private Endpoint  
5. Storage is used for files/blobs, also through a Private Endpoint  

---

## **Testing**

From a VM inside `vnet-data`:

- `nslookup` for SQL / Storage / Key Vault Private Link domains  
- `sqlcmd` or `az sql` to connect to the SQL database  
- `az storage blob list` to test Storage access  
- `az keyvault secret list` to test Key Vault access  

---

## **Lessons Learned**

- Private Endpoints + Private DNS are essential for a secure data platform  
- Managed Identity removes the need for secrets in code  
- Governance (Azure Policy) prevents accidental public exposure  
- A secure data platform must be part of a broader Zero Trust strategy, not an isolated system  



