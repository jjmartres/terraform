/**
  *
  * # Google Cloud Firewall
  *
  * This module is used to create an manage Google Cloud firewall rules
  */
variable "module_depends_on" {
  default = [""]
}

resource "null_resource" "module_depends_on" {
  triggers = {
    value = length(var.module_depends_on)
  }
}

resource "google_compute_firewall" "compute_firewall_rule" {
  name = var.name
  description = var.description
  network = var.network
  direction = upper(var.direction)
  disabled = var.disabled

  log_config {
    metadata = upper(var.log_config)
  }
  priority = var.priority

  dynamic "allow" {
    for_each = [ for p in var.rules: {
      protocol = p.protocol
      ports = p.ports
    }]
    content {
      protocol = allow.value.protocol
      ports = allow.value.ports
      }
  }

  source_ranges = var.source_ranges
  source_tags = var.source_tags
  target_tags = var.target_tags

  depends_on                       = [ null_resource.module_depends_on]
}