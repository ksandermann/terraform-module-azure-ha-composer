resource "azurerm_linux_virtual_machine_scale_set" "this" {
  name                = var.scaleset_name
  resource_group_name = data.azurerm_resource_group.scaleset.name
  location            = var.location
  sku                 = var.scaleset_sku
  instances           = length(var.zones)
  admin_username      = var.scaleset_admin_username
  //TODO
  admin_password                  = "Test123"
  disable_password_authentication = false


  custom_data = base64encode(local.cloud_init_rendered)
  admin_ssh_key {
    username   = var.scaleset_admin_username
    public_key = var.scaleset_admin_ssh_key
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = var.scaleset_storage_account_type
    caching              = "ReadWrite"
  }

  network_interface {
    name    = format("%s%s", var.scaleset_name, "NIC001")
    primary = true

    ip_configuration {
      name                                   = format("%s%s", var.scaleset_name, "PRVIP001")
      primary                                = true
      subnet_id                              = data.azurerm_subnet.scaleset.id
      load_balancer_backend_address_pool_ids = azurerm_lb_backend_address_pool.this.id
    }
  }

  dynamic "boot_diagnostics" {
    for_each = data.azurerm_storage_account.boot_diagnostics.*
    content {
      storage_account_uri = data.azurerm_storage_account.boot_diagnostics[0].primary_blob_endpoint
    }
  }

  //  automatic_os_upgrade_policy {
  //    enable_automatic_os_upgrade = var.scaleset_enable_automatic_os_upgrade
  //    disable_automatic_rollback  = var.scaleset_disable_automatic_rollback
  //  }
}
