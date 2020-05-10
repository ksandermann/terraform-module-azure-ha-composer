
resource "azurerm_lb" "this" {
  name                = var.loadbalancer_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.loadbalancer.name
  sku                 = var.loadbalancer_sku
  tags                = var.loadbalancer_tags

  frontend_ip_configuration {
    name                       = format("%s%s", var.loadbalancer_name, "PRVIP001")
    subnet_id                  = data.azurerm_subnet.loadbalancer.id
    private_ip_address         = local.loadbalancer_frontend_private_ip
    private_ip_address_version = var.loadbalancer_ip_version
    //TODO
    zones = [1]
  }

  dynamic "frontend_ip_configuration" {
    for_each = azurerm_public_ip.this.*
    content {
      name                 = format("%s%s", var.loadbalancer_name, "PUBIP001")
      public_ip_address_id = azurerm_public_ip.this.id
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
