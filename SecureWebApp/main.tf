resource "azurerm_resource_group" "lettyRG" {
  name     = "lettyRG"
  location = var.location
}

resource "azurerm_resource_group" "lettyHubRG" {
  name     = "lettyHubRG"
  location = var.location
}