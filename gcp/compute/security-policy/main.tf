/**
  *
  * # Google Cloud Compute Security Policy (Cloud Armor)
  *
  * This module is used to create and manage security policy rules
  */
resource "google_compute_security_policy" "policy" {
  name = var.name
  description = var.description

  dynamic "rule" {
    for_each = [ for r in var.rules: {
      action = r.action
      priority = r.priority
      description = r.description
      src_ip_ranges: r.src_ip_ranges
    }]
    content {
      action = rule.value.action
      priority = rule.value.priority
      match {
        versioned_expr = "SRC_IPS_V1"
        config {
          src_ip_ranges = rule.value.src_ip_ranges
        }
      }
      description = rule.value.description
      }
    }

  /* default rule */
  rule {
    action = var.default_action
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "default rule"
  }
}