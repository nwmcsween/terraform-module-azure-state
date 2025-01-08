locals {
  _os_type = substr(abspath(path.root), 0, 1) == "/" ? "unix" : "windows" # FIXME: UNC paths?
  _interpreter = {
    windows = ["powershell.exe", "-NoProfile", "-NoLogo", "-NonInteractive", "-WindowStyle", "Hidden", "-File"]
    unix    = ["sh"]
  }
  _script = {
    windows = "${path.module}/assets/migrate_state.ps1"
    unix    = "${path.module}/assets/migrate_state.sh"
  }
}

resource "null_resource" "migrate" {
  depends_on = [
    azurerm_role_assignment.azure, # The role assignment is required to run the script.
    local_file.backend
  ]
  triggers = {
    backend-config = local_file.backend-config.id
    backend        = local_file.backend.id
  }

  provisioner "local-exec" {
    interpreter = local._interpreter[local._os_type]
    command     = local._script[local._os_type]
    environment = {
      TF_BACKEND_CONFIG_FILENAME = local_file.backend-config.filename
      TF_WORK_DIR                = abspath(path.root)
    }
  }
}
