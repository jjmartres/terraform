/*
 * # Google Cloud Routes within VPC network
 *
 * This submodule is part of the `gcp-network` module.  It creates the individual vpc routes and optionally deletes the default Internet gateway routes.
 *
 * It supports creating:
 *
 * - Routes within vpc network.
 * - Optionally deletes the default internet gateway routes
 *
*/
locals {
  routes = {
  for i, route in var.routes :
  lookup(route, "name", format("%s-%s-%d", lower(var.network), "route", i)) => route
  }
}

resource "null_resource" "module_depends_on" {
  triggers = {
    value = length(var.module_depends_on)
  }
}

resource "google_compute_route" "route" {
  for_each = local.routes

  project = var.project
  network = var.network

  name                   = each.key
  description            = lookup(each.value, "description", null)
  tags                   = compact(split(",", lookup(each.value, "tags", "")))
  dest_range             = lookup(each.value, "destination_range", null)
  next_hop_gateway       = lookup(each.value, "next_hop_internet", "false") == "true" ? "default-internet-gateway" : null
  next_hop_ip            = lookup(each.value, "next_hop_ip", null)
  next_hop_instance      = lookup(each.value, "next_hop_instance", null)
  next_hop_instance_zone = lookup(each.value, "next_hop_instance_zone", null)
  next_hop_vpn_tunnel    = lookup(each.value, "next_hop_vpn_tunnel", null)
  next_hop_ilb           = lookup(each.value, "next_hop_ilb", null)
  priority               = lookup(each.value, "priority", null)

  depends_on = [ null_resource.module_depends_on ]
}