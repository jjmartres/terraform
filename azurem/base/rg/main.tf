/**
  *
  * # Azure Resource Group
  *
  * Common Azure terraform module to create a Resource Group  with optional lock.
  */
resource "azurerm_resource_group" "resource-group" {
  name     = var.name
  location = var.location

  tags = var.tags

  timeouts {
    create = var.timeout_create
    read = var.timeout_read
    update = var.timeout_update
    delete = var.timeout_delete
  }
}

resource "azurerm_management_lock" "resource-group-level-lock" {
  name       = "${var.name}-level-lock"
  scope      = azurerm_resource_group.resource-group.id
  lock_level = var.lock_level
  notes      = "Resource Group '${var.name}' is locked with '${var.lock_level}' level."

  count = var.lock_level == "" ? 0 : 1
}