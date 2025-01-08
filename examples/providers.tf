variable "subscription_id" {
  type        = string
  description = "(Required) The Azure Subscription ID."
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
