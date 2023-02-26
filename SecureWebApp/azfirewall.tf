resource "azurerm_subnet" "lettyFirewallSubnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.lettyHubRG.name
  virtual_network_name = azurerm_virtual_network.hubVnet.name
  address_prefixes     = ["10.10.0.0/24"]
}

resource "azurerm_public_ip" "lettyFirewallPIP" {
  name                = "FirewallPIP"
  location            = azurerm_resource_group.lettyHubRG.location
  resource_group_name = azurerm_resource_group.lettyHubRG.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "lettyFirewall" {
  name                = "LettyFirewall"
  location            = azurerm_resource_group.lettyHubRG.location
  resource_group_name = azurerm_resource_group.lettyHubRG.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  threat_intel_mode   = "Deny"
  firewall_policy_id = azurerm_firewall_policy.lettyDefaultFWPolicy.id

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.lettyFirewallSubnet.id
    public_ip_address_id = azurerm_public_ip.lettyFirewallPIP.id
  }
}

