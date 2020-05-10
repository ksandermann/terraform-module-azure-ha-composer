variable "loadbalancer_sku" {
  type    = string
  default = "Standard"
}

variable "loadbalancer_tags" {
  type    = map(string)
  default = {}
}

variable "loadbalancer_frontend_private_ip" {
  type    = string
  default = ""
}

variable "loadbalancer_ip_version" {
  type    = string
  default = "IPv4"
}

variable "loadbalancer_enable_public_ip" {
  type    = bool
  default = false
}

variable "zones" {
  type    = list(number)
  default = [1, 2, 3]
}

locals {
  loadbalancer_frontend_private_ip = var.loadbalancer_frontend_private_ip == "" ? cidrhost(data.azurerm_subnet.loadbalancer.address_prefix, 5) : var.loadbalancer_frontend_private_ip
}

variable "scaleset_sku" {
  type    = string
  default = "Standard_F2s"
}
variable "scaleset_storage_account_type" {
  type    = string
  default = "StandardSSD_LRS"
}
variable "scaleset_disable_automatic_rollback" {
  type    = bool
  default = false
}
variable "scaleset_enable_automatic_os_upgrade" {
  type    = bool
  default = true
}

variable "boot_diagnostics_storage_account_rg_name" {
  type    = string
  default = ""
}

variable "boot_diagnostics_storage_account_name" {
  type    = string
  default = ""
}

variable "boot_diagnostics_enabled" {
  type    = bool
  default = false
}
