data "azurerm_subscription" "this" {
  subscription_id = var.subscription_id
}

data "azurerm_resource_group" "scaleset" {
  name = var.scaleset_rg_name
}

data "azurerm_resource_group" "loadbalancer" {
  name = var.loadbalancer_rg_name
}

data "azurerm_subnet" "scaleset" {
  name                 = var.scaleset_subnet_name
  resource_group_name  = data.azurerm_virtual_network.this.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.this.name
}

data "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  resource_group_name = var.vnet_rg_name
}

data "azurerm_subnet" "loadbalancer" {
  name                 = var.loadbalancer_subnet_name
  resource_group_name  = data.azurerm_virtual_network.this.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.this.name
}


