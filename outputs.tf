output "loadbalancer" {
  value       = azurerm_lb.this
  description = "The loadbalancer resource that was created."
}

output "scaleset" {
  value       = azurerm_linux_virtual_machine_scale_set.this
  description = "The scaleset resource that was created."
}
