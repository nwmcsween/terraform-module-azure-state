variable "backend_filename" {
  description = "(Required) The backend filename."
  type        = string
  default     = "terraform-backend.tf"
}

variable "backend_config_filename" {
  description = "(Required) The backend config filename, this is usually the environment"
  type        = string
}

resource "local_file" "backend" {
  filename = "${path.root}/backend.tf"
  content  = <<-EOT
  # This is a generated partial backend configuration file.
  terraform {
    backend "azurerm" {}
  }
  EOT
}

resource "local_file" "backend-config" {
  filename = "${path.root}/${var.backend_config_filename}"
  content  = <<-EOT
  # This is a generated backend configuration file.
  resource_group_name  = "${var.resource_group_name}"
  storage_account_name = "${azurerm_storage_account.azure.name}"
  container_name       = "${azurerm_storage_container.azure.name}"
  key                  = "terraform.tfstate"
  EOT
}


