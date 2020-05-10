resource "azurerm_linux_virtual_machine_scale_set" "this" {
  name                = var.scaleset_name
  resource_group_name = data.azurerm_resource_group.scaleset.name
  location            = var.location
  sku                 = var.scaleset_sku
  tags                = var.scaleset_tags

  //high-availability
  instances       = length(var.zones)
  zones           = var.zones
  zone_balance    = true
  health_probe_id = azurerm_lb_probe.this.id

  //guest OS
  admin_username                  = var.scaleset_admin_username
  admin_password                  = var.scaleset_admin_password
  disable_password_authentication = var.scaleset_admin_password == "" ? true : false
  custom_data                     = base64encode(local.cloud_init_rendered)
  provision_vm_agent              = true

  //terraform lifecycle
  depends_on = [azurerm_lb_rule.this]
  lifecycle {
    ignore_changes = [
      instances,
    ]
  }

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
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.this.id]
    }
  }

  dynamic "boot_diagnostics" {
    for_each = data.azurerm_storage_account.boot_diagnostics.*
    content {
      storage_account_uri = data.azurerm_storage_account.boot_diagnostics[0].primary_blob_endpoint
    }
  }

  //upgrades
  upgrade_mode    = "Automatic"
  scale_in_policy = "OldestVM"

  rolling_upgrade_policy {
    max_batch_instance_percent              = 34
    max_unhealthy_instance_percent          = 67
    max_unhealthy_upgraded_instance_percent = 67
    pause_time_between_batches              = "PT5M"
  }

  automatic_os_upgrade_policy {
    enable_automatic_os_upgrade = var.scaleset_enable_automatic_os_upgrade
    disable_automatic_rollback  = var.scaleset_disable_automatic_rollback
  }

  automatic_instance_repair {
    enabled      = true
    grace_period = "PT30M"
  }
}

resource "azurerm_monitor_autoscale_setting" "this" {
  count               = var.scaleset_enable_autoscaling ? 1 : 0
  name                = var.scaleset_name
  resource_group_name = azurerm_linux_virtual_machine_scale_set.this.resource_group_name
  location            = azurerm_linux_virtual_machine_scale_set.this.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.this.id

  profile {
    name = var.scaleset_name

    capacity {
      default = length(var.zones)
      minimum = length(var.zones)
      maximum = length(var.zones) + 3
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.this.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.this.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}
