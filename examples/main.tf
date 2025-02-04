data "azurerm_client_config" "main" {}

resource "azurerm_resource_group" "main" {
  #ts:skip=AC_AZURE_0389
  name     = "rg-terraform"
  location = "Canada Central"
}

module "main" {
  source = "../"

  backend_config_filename = "production.tfbackend"
  location                = azurerm_resource_group.main.location
  owner_id                = data.azurerm_client_config.main.object_id
  resource_group_name     = azurerm_resource_group.main.name
}
