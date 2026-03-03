resource "azurerm_public_ip" "afw_pip" {
  name                = "pip-afw-hub-s04"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall_policy" "policy" {
  name                = "afw-policy-s04"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  threat_intel_mode   = "Alert"
}

resource "azurerm_firewall" "afw" {
  name                = "afw-hub-s04"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  firewall_policy_id = azurerm_firewall_policy.policy.id

  ip_configuration {
    name                 = "afw-ipconfig"
    subnet_id            = azurerm_subnet.afw_subnet.id
    public_ip_address_id = azurerm_public_ip.afw_pip.id
  }
}
