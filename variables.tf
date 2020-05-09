variable "subscription_id" {
  type = string
}

variable "scaleset_rg_name" {
  type = string
}

variable "loadbalancer_rg_name" {
  type = string
}

variable "scaleset_subnet_name" {
  type = string
}

variable "vnet_name" {
  type = string
}
variable "vnet_rg_name" {
  type = string
}

variable "loadbalancer_subnet_name" {
  type = string
}

variable "loadbalancer_name" {
  type = string
}
variable "location" {
  type = string
}

variable "scaleset_name" {
  default = ""
}

variable "scaleset_admin_username" {
  default = ""
}
variable "scaleset_admin_ssh_key" {
  default = ""
}
