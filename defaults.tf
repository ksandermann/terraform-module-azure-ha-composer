//generic
variable "zones" {
  type        = list(number)
  default     = [1, 2, 3]
  description = "List of availability zones to use for the scaleset & loadbalancer"
}

// loadbalancer
variable "loadbalancer_sku" {
  type        = string
  default     = "Standard"
  description = "SKU of the loadbalancer"
}

variable "loadbalancer_tags" {
  type        = map(string)
  default     = {}
  description = "Resource Tags to add to the loadbalancer"
}

variable "loadbalancer_frontend_private_ip" {
  type        = string
  default     = ""
  description = "Frontend private IP address of the loadbalancer. Has to be inside the loadbalancer subnet. Only used when loadbalancer_enable_public_ip is set to false (which it is per default). If not provided, the 5th IP inside the subnet will be used."
}

variable "loadbalancer_enable_public_ip" {
  type        = bool
  default     = false
  description = "Wether a new Public IP should be created for the loadbalancer."
}

variable "loadbalancer_enable_snat" {
  type        = bool
  default     = true
  description = "Wether the loadbalancer should be used as SNAT gateway by the scaleset instances."
}

// scaleset
variable "scaleset_sku" {
  type        = string
  default     = "Standard_F2s"
  description = "SKU of the scaleset instances."
}

variable "scaleset_storage_account_type" {
  type        = string
  default     = "StandardSSD_LRS"
  description = "Storageaccount type for the scaleset instances' OS disks."
}

variable "scaleset_boot_diagnostics_enabled" {
  type        = bool
  default     = false
  description = "Wether boot diagnostics should be enabled for the scaleset instances."
}

variable "scaleset_boot_diagnostics_storage_account_rg_name" {
  type        = string
  default     = ""
  description = "Name of the resource group of the storageaccount used to store the boot diagnostics of the scaleset. Only used when scaleset_boot_diagnostics_enabled is set to true. (which it is not by default)"
}

variable "scaleset_boot_diagnostics_storage_account_name" {
  type        = string
  default     = ""
  description = "Name of the storageaccount used to store the boot diagnostics of the scaleset. Only used when scaleset_boot_diagnostics_enabled is set to true. (which it is not by default)"
}

//TODO
variable "scaleset_disable_automatic_rollback" {
  type        = bool
  default     = false
  description = ""
}

variable "scaleset_enable_automatic_os_upgrade" {
  type        = bool
  default     = true
  description = ""
}
