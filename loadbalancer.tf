resource "azurerm_lb" "this" {
  name                = var.loadbalancer_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.loadbalancer.name
  sku                 = var.loadbalancer_sku
  tags                = var.loadbalancer_tags

  //only private
  dynamic "frontend_ip_configuration" {
    for_each = var.loadbalancer_enable_public_ip ? [] : ["enablethis"]
    content {
      name                          = format("%s%s", var.loadbalancer_name, "IP001")
      subnet_id                     = data.azurerm_subnet.loadbalancer.id
      private_ip_address            = local.loadbalancer_frontend_private_ip
      private_ip_address_allocation = "Static"
      private_ip_address_version    = var.loadbalancer_ip_version
      //TODO
      zones = [1]
    }
  }

  //public and private
  dynamic "frontend_ip_configuration" {
    for_each = var.loadbalancer_enable_public_ip ? ["enablethis"] : []
    content {
      name                          = format("%s%s", var.loadbalancer_name, "IP001")
      subnet_id                     = data.azurerm_subnet.loadbalancer.id
      private_ip_address            = local.loadbalancer_frontend_private_ip
      private_ip_address_allocation = "Static"
      private_ip_address_version    = var.loadbalancer_ip_version
      public_ip_address_id          = azurerm_public_ip.this.id
      //TODO
      zones = [1]
    }
  }
}

resource "azurerm_public_ip" "this" {
  count               = var.loadbalancer_enable_public_ip ? 1 : 0
  name                = format("%s%s", var.loadbalancer_name, "PUBIP001")
  location            = var.location
  resource_group_name = data.azurerm_resource_group.loadbalancer.name
  allocation_method   = "Static"
}

resource "azurerm_lb_backend_address_pool" "this" {
  resource_group_name = azurerm_lb.this.resource_group_name
  loadbalancer_id     = azurerm_lb.this.id
  name                = var.scaleset_name
}



resource "azurerm_lb_probe" "this" {
  resource_group_name = azurerm_lb.this.resource_group_name
  loadbalancer_id     = azurerm_lb.this.id
  name                = var.scaleset_name
  port                = var.loadbalancer_healthprobe_port
}

resource "azurerm_lb_rule" "this" {
  for_each                       = var.loadbalancer_ports
  resource_group_name            = azurerm_lb.this.resource_group_name
  loadbalancer_id                = azurerm_lb.this.id
  name                           = format("%s%s%s", each.key, each.value.protocol, each.value.port)
  protocol                       = each.value.protocol
  frontend_port                  = each.value.port
  backend_port                   = each.value.port
  frontend_ip_configuration_name = azurerm_lb.this.frontend_ip_configuration[0].name
  backend_address_pool_id        = azurerm_lb_backend_address_pool.this.id
  probe_id                       = azurerm_lb_probe.this.id
  disable_outbound_snat          = true
}
