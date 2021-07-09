/*
 * # Google Cloud Subnets within VPC network
 *
 * This submodule is part of the `gcp-network` module. It creates the individual `VPC` subnets.
 *
 * It supports creating:
 *
 * - Subnets within vpc network
 *
*/
locals {
  subnets = {
    for x in var.subnets :
    "${x.subnet_region}/${x.subnet_name}" => x
  }
}

resource "null_resource" "module_depends_on" {
  triggers = {
    value = length(var.module_depends_on)
  }
}

resource "google_compute_subnetwork" "subnetwork" {
  for_each = local.subnets
  name = each.value.subnet_name
  ip_cidr_range = each.value.subnet_ip
  region = each.value.subnet_region
  private_ip_google_access = lookup(each.value, "subnet_private_access", "false")
  dynamic "log_config" {
    for_each = lookup(each.value, "subnet_flow_logs", false) ? [
      {
        aggregation_interval = lookup(each.value, "subnet_flow_logs_interval", "INTERVAL_5_SEC")
        flow_sampling = lookup(each.value, "subnet_flow_logs_sampling", "0.5")
        metadata = lookup(each.value, "subnet_flow_logs_metadata", "INCLUDE_ALL_METADATA")
      }] : []
    content {
      aggregation_interval = log_config.value.aggregation_interval
      flow_sampling = log_config.value.flow_sampling
      metadata = log_config.value.metadata
    }
  }
  network = var.network_name
  project = var.project
  description = lookup(each.value, "description", null)
  secondary_ip_range = [
    for i in range(
      length(
        contains(
        keys(var.secondary_ranges), each.value.subnet_name) == true
        ? var.secondary_ranges[each.value.subnet_name]
        : []
    )) :
    var.secondary_ranges[each.value.subnet_name][i]
  ]

  depends_on = [ null_resource.module_depends_on]
}