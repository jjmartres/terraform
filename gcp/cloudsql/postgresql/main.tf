/**
  *
  * # Google CloudSQL instance (PostgreSQL)
  *
  * Note: CloudSQL provides [disk autoresize](https://cloud.google.com/sql/docs/mysql/instance-settings#automatic-storage-increase-2ndgen) feature which can cause a [Terraform configuration drift](https://www.hashicorp.com/blog/detecting-and-managing-drift-with-terraform) due to the value in `disk_size` variable, and hence any updates to this variable is ignored in the [Terraform lifecycle](https://www.terraform.io/docs/configuration/resources.html#ignore_changes).
  */
locals {
  master_instance_name = var.random_instance_name ? "${var.name}-${random_id.suffix[0].hex}" : var.name

  ip_configuration_enabled = length(keys(var.ip_configuration)) > 0 ? true : false

  ip_configurations = {
    enabled  = var.ip_configuration
    disabled = {}
  }

  databases = { for db in var.additional_databases : db.name => db }
  users     = { for u in var.additional_users : u.name => u }
}

resource "random_id" "suffix" {
  count = var.random_instance_name ? 1 : 0

  byte_length = 4
}

resource "google_sql_database_instance" "default" {
  provider            = google-beta
  project             = var.project
  name                = local.master_instance_name
  database_version    = var.database_version
  region              = "${element(split("-", var.location),0)}-${element(split("-", var.location),1)}"
  encryption_key_name = var.encryption_key_name
  deletion_protection = var.deletion_protection

  settings {
    tier              = var.tier
    activation_policy = var.activation_policy
    availability_type = var.availability_type

    dynamic "backup_configuration" {
      for_each = [var.backup_configuration]
      content {
        binary_log_enabled             = false
        enabled                        = lookup(backup_configuration.value, "enabled", null)
        start_time                     = lookup(backup_configuration.value, "start_time", null)
        location                       = lookup(backup_configuration.value, "location", null)
        point_in_time_recovery_enabled = lookup(backup_configuration.value, "point_in_time_recovery_enabled", false)
      }
    }
    dynamic "ip_configuration" {
      for_each = [local.ip_configurations[local.ip_configuration_enabled ? "enabled" : "disabled"]]
      content {
        ipv4_enabled    = lookup(ip_configuration.value, "ipv4_enabled", null)
        private_network = lookup(ip_configuration.value, "private_network", null)
        require_ssl     = lookup(ip_configuration.value, "require_ssl", null)

        dynamic "authorized_networks" {
          for_each = lookup(ip_configuration.value, "authorized_networks", [])
          content {
            expiration_time = lookup(authorized_networks.value, "expiration_time", null)
            name            = lookup(authorized_networks.value, "name", null)
            value           = lookup(authorized_networks.value, "value", null)
          }
        }
      }
    }

    disk_autoresize = var.disk_autoresize
    disk_size       = var.disk_size
    disk_type       = var.disk_type
    pricing_plan    = var.pricing_plan
    dynamic "database_flags" {
      for_each = var.database_flags
      content {
        name  = lookup(database_flags.value, "name", null)
        value = lookup(database_flags.value, "value", null)
      }
    }

    user_labels = merge({"terraform": true },var.user_labels)

    location_preference {
      zone = var.location
    }

    maintenance_window {
      day          = var.maintenance_window_day
      hour         = var.maintenance_window_hour
      update_track = var.maintenance_window_update_track
    }
  }

  lifecycle {
    ignore_changes = [
      settings[0].disk_size
    ]
  }

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }

  depends_on = [null_resource.module_depends_on]
}

resource "null_resource" "module_depends_on" {
  triggers = {
    value = length(var.module_depends_on)
  }
}