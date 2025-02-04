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

variable "storage_soft_delete_days" {
  default     = 30
  description = "(Optional) The days at which the storage account soft delete expires."
  type        = number
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
  #checkov:skip=CKV2_AZURE_1 - Customer managed keys don't matter as Opentofu state encryption should be used.
  #checkov:skip=CKV_AZURE_59 - Oublic access is needed in order to change state, etc in emergency.
  #checkov:skip=CKV_AZURE_33 - TODO: Storage logging.
  #checkov:skip=CKV2_AZURE_33
  #checkov:skip=CKV_AZURE_44
  name                = "satf${random_string.azure.result}"
  resource_group_name = var.resource_group_name
  location            = var.location

  account_tier                    = "Standard"
  account_replication_type        = "GZRS"
  default_to_oauth_authentication = true
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = false
  local_user_enabled              = false
  tags                            = var.tags

  blob_properties {
    delete_retention_policy {
      days = var.storage_soft_delete_days
    }
  }
}


resource "azurerm_storage_container" "azure" {
  #checkov:skip=CKV2_AZURE_21,
  #checkov:skip=CKV2_AZURE_1 - Use Opentofu state encryption instead of customer managed keys
  #checkov:skip=CKV2_AZURE_33 - Private endpoint cannot be used until conncetivity is setup
  name               = "terraform"
  storage_account_id = azurerm_storage_account.azure.id
}

resource "azurerm_role_assignment" "azure" {
  scope                = azurerm_storage_account.azure.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.owner_id
}
