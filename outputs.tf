output "loadbalancer" {
  value = azurerm_lb.this
}

output "scaleset" {
  value = azurerm_linux_virtual_machine_scale_set.this
}
