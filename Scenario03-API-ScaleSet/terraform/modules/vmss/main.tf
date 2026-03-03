resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = "vmss-api"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = "Standard_B2s"
  instances           = 1
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-noble"
    sku       = "24_04-lts"
    version   = "latest"
  }

  network_interface {
    name    = "nicConfig"
    primary = true

    ip_configuration {
      name                                   = "ipconfig1"
      subnet_id                              = var.subnet_id
      load_balancer_backend_address_pool_ids = [var.backend_pool_id]
    }
  }

  extension {
    name                 = "CustomScript"
    publisher            = "Microsoft.Azure.Extensions"
    type                 = "CustomScript"
    type_handler_version = "2.1"

    settings = <<SETTINGS
{
  "commandToExecute": "bash -c 'sudo apt-get update && sudo apt-get install -y nginx && echo API instance running on $(hostname) | sudo tee /var/www/html/index.html && sudo systemctl enable nginx && sudo systemctl restart nginx'"
}
SETTINGS
  }
}
