resource "azurerm_virtual_network" "hub" {
  name                = "vnet-hub-s04"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.40.0.0/16"]
}

resource "azurerm_subnet" "afw_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.40.1.0/24"]
}

resource "azurerm_virtual_network" "spoke" {
  name                = "vnet-spoke-s04"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.45.0.0/16"]
}

resource "azurerm_subnet" "subnet_app" {
  name                 = "subnet-app"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.45.1.0/24"]
}

resource "azurerm_subnet" "subnet_app_wapp" {
  name                 = "subnet-app-wapp"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.45.0.0/24"]
}

resource "azurerm_subnet" "subnet_pe_webapp" {
  name                 = "subnet-pe-webapp"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.45.2.0/24"]
}

resource "azurerm_route_table" "rt_spoke" {
  name                = "rt-spoke-s04"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  route {
    name                   = "default-to-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.afw.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "rt_app" {
  subnet_id      = azurerm_subnet.subnet_app.id
  route_table_id = azurerm_route_table.rt_spoke.id
}

resource "azurerm_subnet_route_table_association" "rt_pe_webapp" {
  subnet_id      = azurerm_subnet.subnet_pe_webapp.id
  route_table_id = azurerm_route_table.rt_spoke.id
}
