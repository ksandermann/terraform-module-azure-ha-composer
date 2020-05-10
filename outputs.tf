output "dbug" {
  value = base64decode(azurerm_linux_virtual_machine_scale_set.this.custom_data)
}
