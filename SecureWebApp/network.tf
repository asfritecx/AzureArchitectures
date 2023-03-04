// Network and subnets
resource "azurerm_virtual_network" "lettyVNET" {
  name                = "Letty-Net"
  address_space       = [var.vnetcidr]
  location            = azurerm_resource_group.lettyRG.location
  resource_group_name = azurerm_resource_group.lettyRG.name
}

resource "azurerm_virtual_network" "hubVnet" {
  name                = "letty-hub"
  address_space       = [var.hubcidr]
  location            = azurerm_resource_group.lettyHubRG.location
  resource_group_name = azurerm_resource_group.lettyHubRG.name
}

resource "azurerm_subnet" "frontendSubnet" {
  name                 = "frontendSubnet"
  resource_group_name  = azurerm_resource_group.lettyRG.name
  virtual_network_name = azurerm_virtual_network.lettyVNET.name
  address_prefixes     = [var.webcidr]
}

resource "azurerm_subnet" "backendSubnet" {
  name                 = "backendSubnet"
  resource_group_name  = azurerm_resource_group.lettyRG.name
  virtual_network_name = azurerm_virtual_network.lettyVNET.name
  address_prefixes     = [var.dbcidr]
}

// Network Interface Cards NIC
resource "azurerm_network_interface" "webserverNIC" {
  name                = "web-server-nic"
  location            = azurerm_resource_group.lettyRG.location
  resource_group_name = azurerm_resource_group.lettyRG.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.frontendSubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.10.10"
  }
}

resource "azurerm_network_interface" "dbserverNIC" {
  name                = "db-server-nic"
  location            = azurerm_resource_group.lettyRG.location
  resource_group_name = azurerm_resource_group.lettyRG.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.backendSubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.20.20"
  }
}

// VNET Peering
resource "azurerm_virtual_network_peering" "peerhubtoletty" {
  name                      = "peerhubtoletty"
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
  resource_group_name       = azurerm_resource_group.lettyHubRG.name
  virtual_network_name      = azurerm_virtual_network.hubVnet.name
  remote_virtual_network_id = azurerm_virtual_network.lettyVNET.id
}

resource "azurerm_virtual_network_peering" "peerlettytohub" {
  name                      = "peerlettytohub"
  resource_group_name       = azurerm_resource_group.lettyRG.name
  virtual_network_name      = azurerm_virtual_network.lettyVNET.name
  remote_virtual_network_id = azurerm_virtual_network.hubVnet.id
}