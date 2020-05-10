//generic
variable "subscription_id" {
  type        = string
  description = "ID of the subscription to use"
}

variable "vnet_name" {
  type        = string
  description = "Name of the VNET where the scaleset and optionally the loadbalancer subnet reside in. Has to be created beforehand outside of this module."
}

variable "vnet_rg_name" {
  type        = string
  description = "Name of the resource group of the VNET where the scaleset and optionally the loadbalancer subnet reside in. Has to be created beforehand outside of this module."
}

variable "location" {
  type        = string
  description = "Location that will be used for all resources inside this module"
}

variable "docker_compose_file_b64" {
  type        = string
  description = "Base64-encoded file content of the docker-compose file."
}

variable "container_config_files" {
  type = map(object({
    host_path        = string
    file_content_b64 = string
  }))
  description = "Config files to place on the scaleset instances. Both the path on the host system as well as the file content (base64-encoded) can be provided. These file can be mounted into the container inside the docker-compose file."
}

//loadbalancer
variable "loadbalancer_rg_name" {
  type        = string
  description = "Name of the resource group to place the loadbalancer in. Has to be created beforehand outside of this module."
}

variable "loadbalancer_name" {
  type        = string
  description = "Name of the loadbalancer resource"
}

variable "loadbalancer_subnet_name" {
  type        = string
  description = "Name of the subnet to place the loadbalancer private frontend IP in."
}

variable "loadbalancer_ports" {
  type = map(object({
    port     = number
    protocol = string
  }))
  description = "Ports that the loadbalancer should pass-through to the scaleset instances. These should be used by the containers inside the docker-compose file."
}

variable "loadbalancer_healthprobe_port" {
  type        = number
  description = "Tcp Port for the loadbalancer to determine the health of a scaleset instance. This should be used by the containers inside the docker-compose file."
}

//scaleset
variable "scaleset_rg_name" {
  type        = string
  description = "Name of the resource group to place the scaleset in. Has to be created beforehand outside of this module."
}

variable "scaleset_name" {
  type        = string
  description = "Name of the scaleset resource"
}

variable "scaleset_subnet_name" {
  type        = string
  description = "Name of the subnet to place the scaleset in. Has to be created beforehand outside of this module."
}

variable "scaleset_admin_ssh_key" {
  type        = string
  description = "Public SSH key for the scaleset's instances' admin user."
}
