terraform {
  required_version = ">= 1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2"
    }
  }
}
