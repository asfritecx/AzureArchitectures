// APPNSG
resource "azurerm_network_security_group" "webnsg" {
  name                = "WebNSG"
  location            = var.location
  resource_group_name = azurerm_resource_group.lettyRG.name
}

resource "azurerm_network_security_rule" "webNsgInbound" {
  name                        = "AllowHTTPS"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.lettyRG.name
  network_security_group_name = azurerm_network_security_group.webnsg.name
}

resource "azurerm_network_interface_security_group_association" "webNSGAssoc" {
  network_interface_id      = azurerm_network_interface.webserverNIC.id
  network_security_group_id = azurerm_network_security_group.webnsg.id
}

// Database NSG
resource "azurerm_network_security_group" "dbnsg" {
  name                = "DbNSG"
  location            = var.location
  resource_group_name = azurerm_resource_group.lettyRG.name
}

resource "azurerm_network_security_rule" "dbNsgInbound" {
  name                        = "AllowSQL"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1433 - 1434"
  source_address_prefix       = var.webcidr
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.lettyRG.name
  network_security_group_name = azurerm_network_security_group.dbnsg.name
}

resource "azurerm_network_interface_security_group_association" "dbNSGAssoc" {
  network_interface_id      = azurerm_network_interface.dbserverNIC.id
  network_security_group_id = azurerm_network_security_group.dbnsg.id
}
