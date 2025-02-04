terraform {
  required_version = ">= 1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2"
    }
    null = {
      source = "hashicorp/null"
      version = "~> 3"
    }
  }
}
