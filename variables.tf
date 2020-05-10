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
  type = string
}

variable "scaleset_admin_username" {
  type = string
}
variable "scaleset_admin_ssh_key" {
  type = string
}

variable "docker_compose_file_b64" {
  type = string
}

variable "container_config_files" {
  type = map(object({
    host_path        = string
    file_content_b64 = string
  }))
}

variable "loadbalancer_ports" {
  type = map(object({
    port     = number
    protocol = string
  }))
  description = "first has to be tcp and will be used for health probes"
}

variable "loadbalancer_healthprobe_port" {
  type = number
}
