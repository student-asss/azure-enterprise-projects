resource "azurerm_storage_account" "sa" {
  name                     = "stors04"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  allow_blob_public_access = false
}

resource "azurerm_mssql_server" "sql" {
  name                         = "sql-s04-server"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = "northeurope"
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
  minimum_tls_version          = "1.2"
  public_network_access_enabled = false
}

resource "azurerm_mssql_database" "db" {
  name           = "db-s04"
  server_id      = azurerm_mssql_server.sql.id
  sku_name       = "Basic"
}

resource "azurerm_key_vault" "kv" {
  name                = "kv-s04"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
}

data "azurerm_client_config" "current" {}
