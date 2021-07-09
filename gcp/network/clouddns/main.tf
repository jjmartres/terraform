/**
  *
  * # Google Cloud DNS
  *
  * This module makes it easy to create Google Cloud DNS zones of different types, and manage their records. It supports creating public, private, forwarding, and peering zones.
  *
  * The resources/services/activations/deletions that this module will create/trigger are:
  *
  *  - One `google_dns_managed_zone` for the zone
  *  - Zero or more `google_dns_record_set` for the zone recordsThis module is used to create an manage Google Kubernetes Cluster
  */
locals {
  is_static_zone = var.type == "public" || var.type == "private"
}

resource "google_dns_managed_zone" "peering" {
  count       = var.type == "peering" ? 1 : 0
  provider    = google-beta
  project     = var.project
  name        = var.name
  dns_name    = var.domain
  description = var.description
  labels      = var.labels
  visibility  = "private"

  private_visibility_config {
    dynamic "networks" {
      for_each = var.private_visibility_config_networks
      content {
        network_url = networks.value
      }
    }
  }

  peering_config {
    target_network {
      network_url = var.target_network
    }
  }
}

resource "google_dns_managed_zone" "forwarding" {
  count       = var.type == "forwarding" ? 1 : 0
  provider    = google-beta
  project     = var.project
  name        = var.name
  dns_name    = var.domain
  description = var.description
  labels      = var.labels
  visibility  = "private"

  private_visibility_config {
    dynamic "networks" {
      for_each = var.private_visibility_config_networks
      content {
        network_url = networks.value
      }
    }
  }

  forwarding_config {
    dynamic "target_name_servers" {
      for_each = var.target_name_server_addresses
      content {
        ipv4_address = target_name_servers.value
      }
    }
  }
}

resource "google_dns_managed_zone" "private" {
  count       = var.type == "private" ? 1 : 0
  project     = var.project
  name        = var.name
  dns_name    = var.domain
  description = var.description
  labels      = var.labels
  visibility  = "private"

  private_visibility_config {
    dynamic "networks" {
      for_each = var.private_visibility_config_networks
      content {
        network_url = networks.value
      }
    }
  }
}

resource "google_dns_managed_zone" "public" {
  count       = var.type == "public" ? 1 : 0
  project     = var.project
  name        = var.name
  dns_name    = var.domain
  description = var.description
  labels      = var.labels
  visibility  = "public"

  dynamic "dnssec_config" {
    for_each = var.dnssec_config == {} ? [] : list(var.dnssec_config)
    iterator = config
    content {
      kind          = lookup(config.value, "kind", "dns#managedZoneDnsSecConfig")
      non_existence = lookup(config.value, "non_existence", "nsec3")
      state         = lookup(config.value, "state", "off")

      default_key_specs {
        algorithm  = lookup(var.default_key_specs_key, "algorithm", "rsasha256")
        key_length = lookup(var.default_key_specs_key, "key_length", 2048)
        key_type   = lookup(var.default_key_specs_key, "key_type", "keySigning")
        kind       = lookup(var.default_key_specs_key, "kind", "dns#dnsKeySpec")
      }
      default_key_specs {
        algorithm  = lookup(var.default_key_specs_zone, "algorithm", "rsasha256")
        key_length = lookup(var.default_key_specs_zone, "key_length", 1024)
        key_type   = lookup(var.default_key_specs_zone, "key_type", "zoneSigning")
        kind       = lookup(var.default_key_specs_zone, "kind", "dns#dnsKeySpec")
      }
    }
  }

}

resource "google_dns_record_set" "cloud-static-records" {
  project      = var.project
  managed_zone = var.name

  for_each = { for record in var.recordsets : join("/", [record.name, record.type]) => record }
  name = (
  each.value.name != "" ?
  "${each.value.name}.${var.domain}" :
  var.domain
  )
  type = each.value.type
  ttl  = each.value.ttl

  rrdatas = each.value.records

  depends_on = [
    google_dns_managed_zone.private,
    google_dns_managed_zone.public,
  ]
}