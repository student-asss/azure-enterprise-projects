resource "azurerm_key_vault" "kv" {
  name                        = "kv-s07-devops"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = false
  soft_delete_retention_days  = 7
}

data "azurerm_client_config" "current" {}

output "kv_name" {
  value = azurerm_key_vault.kv.name
}

