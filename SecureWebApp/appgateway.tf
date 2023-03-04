// App Gateway Subnet
resource "azurerm_subnet" "appGwSubnet" {
  name                 = "AppGWSubnet"
  resource_group_name  = azurerm_resource_group.lettyHubRG.name
  virtual_network_name = azurerm_virtual_network.hubVnet.name
  address_prefixes     = ["10.10.200.0/24"]
}

// App Gateway Subnet NSG
resource "azurerm_network_security_group" "appGwNSG" {
  name                = "AppGWNSG"
  location            = var.location
  resource_group_name = azurerm_resource_group.lettyHubRG.name
}

resource "azurerm_network_security_rule" "appGWNsgInbound2" {
  name                        = "RequiredAzurePorts"
  priority                    = 450
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "65200 - 65535"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.lettyHubRG.name
  network_security_group_name = azurerm_network_security_group.appGwNSG.name
}

resource "azurerm_network_security_rule" "appGWNsgInbound" {
  name                        = "AllowHTTP"
  priority                    = 500
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.lettyHubRG.name
  network_security_group_name = azurerm_network_security_group.appGwNSG.name
}

// Associate to App GW Subnet
resource "azurerm_subnet_network_security_group_association" "appGWNSGAssoc" {
  subnet_id = azurerm_subnet.appGwSubnet.id
  network_security_group_id = azurerm_network_security_group.appGwNSG.id
}

resource "azurerm_public_ip" "appGWPIP" {
  name                = "AppGw-pip"
  resource_group_name = azurerm_resource_group.lettyHubRG.name
  location            = azurerm_resource_group.lettyHubRG.location
  allocation_method   = "Static"
  sku = "Standard"
}

locals {
  backend_address_pool_name      = "${azurerm_virtual_network.hubVnet.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.hubVnet.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.hubVnet.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.hubVnet.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.hubVnet.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.hubVnet.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.hubVnet.name}-rdrcfg"
}

resource "azurerm_application_gateway" "lettyAppGW" {
  name                = "Letty-AppGw"
  resource_group_name = azurerm_resource_group.lettyHubRG.name
  location            = azurerm_resource_group.lettyHubRG.location

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
  }

  autoscale_configuration {
    min_capacity = 1
    max_capacity = 3
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.appGwSubnet.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.appGWPIP.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
    ip_addresses = [ var.appGWbackendpool1 ]
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority = 100
  }

  waf_configuration {
    enabled = true
    firewall_mode = "Prevention"
    rule_set_type = "OWASP"
    rule_set_version = "3.2"
    file_upload_limit_mb = 50
  }
}
