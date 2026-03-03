# Scenario 03 – Scalable Private API Backend (VMSS + Internal Load Balancer)

## 🎯 Objective
Design and deploy a scalable, secure, private API backend using Azure Virtual Machine Scale Sets and an Internal Load Balancer.
The environment must support horizontal scaling, enforce network isolation, and provide a reliable backend service without exposing any public endpoints.

### **This scenario demonstrates:**
- Horizontal scaling with VM Scale Sets
- Private only backend using Internal Load Balancer (ILB)
- Network segmentation with NSG
- Health probes and load balancing
- Autoscaling rules
- Monitoring and observability

---

## Architecture Overview
This scenario builds a private compute backend inside a dedicated Virtual Network.
Traffic flows only internally, and the backend is reachable exclusively through an Internal Load Balancer.
A Network Security Group enforces strict inbound rules, and the VM Scale Set provides automatic scaling and resiliency.

### **Key components:**
- Resource Group (rg-s03-api)
- Virtual Network (vnet-api) with backend subnet
- Network Security Group (nsg-backend)
- Internal Load Balancer (ilb-api)
- VM Scale Set (vmss-api) with 2 instances
- Health probe + load balancing rule
- Autoscaling configuration
- Log Analytics Workspace for monitoring

---

## Azure Services Used
- Resource Group
- Virtual Network
- Subnet
- Network Security Group
- Internal Load Balancer
- VM Scale Set
- Custom Script Extension (Nginx API)
- Autoscale rules
- Log Analytics Workspace
- Azure Monitor Agent

---

## Network Design
- VNet: 10.30.0.0/16
- Subnet: 10.30.1.0/24
- NSG Rules: 
    - Allow internal traffic (10.0.0.0/8)
    - Deny all inbound Internet traffic
    - Outbound allowed (default)

This ensures the backend is fully private, reachable only from inside the VNet.

---

## Compute Layer
- VM Scale Set: vmss-api
- Instances: 2 (autoscaling enabled)
- OS: Ubuntu 22.04 LTS
- Size: Standard B1ms
- Public IP: None
- Load Balancer: Internal only
- Custom Script Extension: Installs Nginx and exposes a simple API page

#### **Example script:**
#!/bin/bash
sudo apt update -y
sudo apt install -y nginx
echo "API instance running on $(hostname)" | sudo tee /var/www/html/index.html

---

## Load Balancing
Internal Load Balancer (ILB)
- Frontend: Private IP in backend subnet
- Backend pool: VMSS instances
- Health probe: TCP 80
- Load balancing rule: Port 80 → Port 80

This ensures traffic is distributed evenly across VMSS instances.

---

## Autoscaling
Autoscale rules ensure the backend scales based on CPU load.
### **Scale out**
- CPU > 70% for 5 minutes
- Add 1 instance
### **Scale in**
- CPU < 30% for 10 minutes
- Remove 1 instance
### **Limits**
- Minimum: 2
- Maximum: 5

---

## Monitoring
A dedicated Log Analytics Workspace (law-s03) collects:
- VMSS metrics
- Nginx logs (if configured)
- Autoscale events
- NSG flow logs (optional)

Azure Monitor Agent is installed on all VMSS instances.

---

## Security Considerations
- No public IPs anywhere in the architecture
- NSG blocks all inbound Internet traffic
- Internal Load Balancer only
- Private VNet segmentation
- VMSS instances accessible only from inside the VNet
- Least privilege network design

---

## Testing
To test the ILB:
1.	Deploy a small test VM inside the same VNet
2.	SSH/RDP into the test VM
3.	Run:
curl http://<ILB-private-IP>

### **Expected output:**
API instance running on vmss-api_00000X
Refreshing multiple times should show different hostnames → confirming load balancing.

---

## Lessons Learned
- Internal Load Balancers are essential for private backend architectures
- VM Scale Sets provide simple, cost efficient horizontal scaling
- NSG rules must be carefully designed to avoid accidental exposure
- Autoscaling ensures performance without overspending
- Monitoring is critical for understanding backend behavior
- Private only architectures significantly reduce attack surface
