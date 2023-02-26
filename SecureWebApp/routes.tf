//Route Tables
// Frontend Subnet Route Table and Routes
resource "azurerm_route_table" "frontendRT" {
  name                = "Frontend_to_Firewall"
  location            = azurerm_resource_group.lettyRG.location
  resource_group_name = azurerm_resource_group.lettyRG.name
}

resource "azurerm_route" "frontendDefaultRoute" {
  name                   = "DefaultRoute"
  resource_group_name    = azurerm_resource_group.lettyRG.name
  route_table_name       = azurerm_route_table.frontendRT.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.firewallPvtIP
}

resource "azurerm_route" "frontendToFirewall" {
  name                   = "RouteAllToFirewall"
  resource_group_name    = azurerm_resource_group.lettyRG.name
  route_table_name       = azurerm_route_table.frontendRT.name
  address_prefix         = "10.0.0.0/16"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.firewallPvtIP
}

resource "azurerm_route" "frontendRoute" {
  name                = "frontendTraffic"
  resource_group_name = azurerm_resource_group.lettyRG.name
  route_table_name    = azurerm_route_table.frontendRT.name
  address_prefix      = var.webcidr
  next_hop_type       = "VnetLocal"
}


resource "azurerm_route" "appgwRoute" {
  name                = "AppGw"
  resource_group_name = azurerm_resource_group.lettyRG.name
  route_table_name    = azurerm_route_table.frontendRT.name
  address_prefix      = "10.10.200.0/24"
  next_hop_type       = "VirtualAppliance"
  next_hop_in_ip_address = var.firewallPvtIP
}

// Backend Route Tables & Routes
resource "azurerm_route_table" "backendRT" {
  name                = "Backend_to_Firewall"
  location            = azurerm_resource_group.lettyRG.location
  resource_group_name = azurerm_resource_group.lettyRG.name
}

resource "azurerm_route" "backendDefaultRoute" {
  name                   = "DefaultRoute"
  resource_group_name    = azurerm_resource_group.lettyRG.name
  route_table_name       = azurerm_route_table.backendRT.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.firewallPvtIP
}

resource "azurerm_route" "backendToFirewall" {
  name                   = "RouteAllToFirewall"
  resource_group_name    = azurerm_resource_group.lettyRG.name
  route_table_name       = azurerm_route_table.backendRT.name
  address_prefix         = "10.0.0.0/16"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.firewallPvtIP
}

resource "azurerm_route" "backendRoute" {
  name                = "VnetLocal"
  resource_group_name = azurerm_resource_group.lettyRG.name
  route_table_name    = azurerm_route_table.backendRT.name
  address_prefix      = var.dbcidr
  next_hop_type       = "VnetLocal"
}


// App Gateway Route Tables & Routes
resource "azurerm_route_table" "appGWRT" {
  name                = "AppGW_to_Lettyapp_Firewall"
  location            = azurerm_resource_group.lettyHubRG.location
  resource_group_name = azurerm_resource_group.lettyHubRG.name
}

resource "azurerm_route" "appGwAppDefaultRoute" {
  name                   = "DefaultRoute"
  resource_group_name    = azurerm_resource_group.lettyHubRG.name
  route_table_name       = azurerm_route_table.appGWRT.name
  address_prefix         = var.webcidr
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.firewallPvtIP
}

// Route Table Associations
resource "azurerm_subnet_route_table_association" "frontendRouteAssociation" {
  depends_on = [
    azurerm_route_table.frontendRT
  ]
  subnet_id      = azurerm_subnet.frontendSubnet.id
  route_table_id = azurerm_route_table.frontendRT.id
}

resource "azurerm_subnet_route_table_association" "backendRouteAssociation" {
  depends_on = [
    azurerm_route_table.backendRT
  ]
  subnet_id      = azurerm_subnet.backendSubnet.id
  route_table_id = azurerm_route_table.backendRT.id
}

resource "azurerm_subnet_route_table_association" "appGWRouteAssociation" {
  depends_on = [
    azurerm_route_table.appGWRT
  ]
  subnet_id      = azurerm_subnet.appGwSubnet.id
  route_table_id = azurerm_route_table.appGWRT.id
}