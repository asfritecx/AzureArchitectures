// Creates a Bastion 
resource "azurerm_subnet" "bastionSubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.lettyRG.name
  virtual_network_name = azurerm_virtual_network.lettyVNET.name
  address_prefixes     = [var.bastioncidr]
}

resource "azurerm_public_ip" "bastionPIP" {
  name                = "BastionPIP"
  location            = azurerm_resource_group.lettyRG.location
  resource_group_name = azurerm_resource_group.lettyRG.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "lettyBastion" {
  name                = "LettyBastionHost"
  location            = azurerm_resource_group.lettyRG.location
  resource_group_name = azurerm_resource_group.lettyRG.name
  sku = "Standard"
  ip_connect_enabled = true
  file_copy_enabled = true
  tunneling_enabled = true
  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastionSubnet.id
    public_ip_address_id = azurerm_public_ip.bastionPIP.id
  }
}