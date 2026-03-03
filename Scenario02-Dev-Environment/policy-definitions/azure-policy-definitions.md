# Azure Policy Definitions Used in This Project
This document lists the exact Azure Policy definitions implemented in the rg-s02-dev resource group as part of the secure development environment configuration.

## 1. Not allowed resource types
Category: Security / Governance
Policy Type: Built‑in
Effect: Deny

Description
Prevents the creation of specific Azure resource types within the assigned scope.
Used to block resources that should not exist in a secure environment.

Parameters Used
json
{
  "notAllowedResourceTypes": [
    "Microsoft.Network/publicIPAddresses"
  ]
}
Purpose in This Project
Ensures no Public IP Address resources can be created in the rg-s02-dev resource group.

Enforces a private‑only network model.

Supports a Bastion‑only access strategy.

## 2. Network interfaces should not have public IPs
Category: Network
Policy Type: Built‑in
Effect: Audit (may be Deny depending on assignment)

Description
Ensures that network interfaces (NICs) do not have public IP addresses associated with them.

Parameters
This policy has no parameters.

Purpose in This Project
Prevents VMs from receiving a public IP through their NIC.

Ensures all compute resources remain private.

Complements the “Not allowed resource types” policy by blocking public IPs at the NIC level.

## Summary
Policy Name	Effect	Purpose
Not allowed resource types	Deny	Blocks creation of Public IP resources
Network interfaces should not have public IPs	Audit/Deny	Prevents NICs from being associated with Public IPs
Together, these policies enforce a zero‑trust, private‑only network architecture where the only entry point is Azure Bastion.