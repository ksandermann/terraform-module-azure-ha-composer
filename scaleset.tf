resource "azurerm_linux_virtual_machine_scale_set" "this" {
  name                = var.scaleset_name
  resource_group_name = data.azurerm_resource_group.scaleset.name
  location            = var.location
  sku                 = var.scaleset_sku
  instances           = length(var.zones)
  admin_username      = var.scaleset_admin_username
  //TODO
  admin_password = "test123"
  custom_data = base64encode(
    templatefile("${path.module}/templates/cloud-init.tmpl",
      {
        systemd_service_file_b64 = base64encode(data.template_file.systemd_service.rendered)
        docker_compose_file_b64  = var.docker_compose_file_b64
        container_config_files   = var.container_config_files
      }
    )
  )
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
      name      = format("%s%s", var.scaleset_name, "PRVIP001")
      primary   = true
      subnet_id = data.azurerm_subnet.scaleset.id
    }
  }

  automatic_os_upgrade_policy {
    enable_automatic_os_upgrade = var.scaleset_enable_automatic_os_upgrade
    disable_automatic_rollback  = var.scaleset_disable_automatic_rollback
  }
}
