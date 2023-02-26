resource "azurerm_firewall_policy" "lettyDefaultFWPolicy" {
  name                = "default-policy"
  resource_group_name = azurerm_resource_group.lettyHubRG.name
  location            = azurerm_resource_group.lettyHubRG.location
}

resource "azurerm_firewall_policy_rule_collection_group" "lettyFirewallGroup1" {
  name               = "lettyFirewallGroup1"
  firewall_policy_id = azurerm_firewall_policy.lettyDefaultFWPolicy.id
  priority           = 500
  /*
  application_rule_collection {
    name     = "app_rule_collection1"
    priority = 500
    action   = "Deny"
    rule {
      name = "app_rule_collection1_rule1"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = ["10.0.0.1"]
      destination_fqdns = ["*.microsoft.com"]
    }
  }*/

  network_rule_collection {
    name     = "default network rules"
    priority = 400
    action   = "Allow"
    rule {
      name                  = "AllowOutboundHTTPS"
      protocols             = ["TCP"]
      source_addresses      = ["10.0.10.0/24", "10.0.20.0/24"]
      destination_addresses = ["0.0.0.0/0"]
      destination_ports     = ["443"]
    }
    rule {
      name                  = "AllowHTTPFromAppGw"
      protocols             = ["TCP"]
      source_addresses      = ["10.10.200.0/24"]
      destination_addresses = ["10.0.10.10"]
      destination_ports     = ["80"]
    }
  }
  /*
  nat_rule_collection {
    name     = "nat_rule_collection1"
    priority = 300
    action   = "Dnat"
    rule {
      name                = "nat_rule_collection1_rule1"
      protocols           = ["TCP", "UDP"]
      source_addresses    = ["10.0.0.1", "10.0.0.2"]
      destination_address = "192.168.1.1"
      destination_ports   = ["80"]
      translated_address  = "192.168.0.1"
      translated_port     = "8080"
    }
  }*/
}
