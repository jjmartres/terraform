/**
  *
  * # Google Cloud Compute URL map
  *
  * This module is used to create an manage Google Cloud Compute URL map
  */
resource "google_compute_url_map" "url_map" {
  name = var.name
  project = var.project
  description = var.description

  default_service = var.default_service

  dynamic "host_rule" {
    for_each = [for r in var.rules: {
      hosts = r.hosts
      path_matcher = r.path_matcher
    }]
    content {
      hosts = host_rule.value.hosts
      path_matcher = host_rule.value.hosts
    }
  }

  dynamic "path_matcher" {
    for_each = [for r in var.rules: {
      name = r.path_matcher
      default_service = r.default_service
      path_rules = r.path_rules
    }]
    content {
      name = path_matcher.value.name
      default_service = path_matcher.value.default_service

      dynamic "path_rule" {
        for_each = [ for p in path_matcher.value.path_rules: {
          paths = p.paths
          service = p.service
        }]
        content {
          paths = path_rule.value.paths
          service = path_rule.value.service
        }
      }
    }
  }

}
