variable "location" {
  type        = string
  description = "(Required) The location to create the resources."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The resource group name."
}

variable "tags" {
  default     = null
  description = "(Optional) A mapping of tags to assign to the resources."
  type        = map(string)
}

variable "owner_id" {
  description = "(Required) The Azure Entra owner principal/object id."
  type        = string
}

resource "random_string" "azure" {
  length  = 6
  special = false
  upper   = false
  numeric = false
}

resource "azurerm_storage_account" "azure" {
  name                = "satf${random_string.azure.result}"
  resource_group_name = var.resource_group_name
  location            = var.location

  account_tier                    = "Standard"
  account_replication_type        = "ZRS"
  default_to_oauth_authentication = true
  tags                            = var.tags
}

resource "azurerm_storage_container" "azure" {
  name               = "terraform"
  storage_account_id = azurerm_storage_account.azure.id
}

resource "azurerm_role_assignment" "azure" {
  scope                = azurerm_storage_account.azure.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.owner_id
}
