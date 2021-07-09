/*
 * # Google Cloud VPC network
 *
 * This submodule is part of the the `gcp-network` module. It creates a vpc network and optionally enables it as a Shared VPC host project.
 *
 * It supports creating:
 *
 * - A VPC Network
 * - Optionally enabling the network as a Shared VPC host
 *
*/
resource "null_resource" "module_depends_on" {
  triggers = {
    value = length(var.module_depends_on)
  }
}

// VPC configuration
resource "google_compute_network" "network" {
  name                            = var.network_name
  auto_create_subnetworks         = var.auto_create_subnetworks
  routing_mode                    = upper(var.routing_mode)
  project                         = var.project
  description                     = var.description
  delete_default_routes_on_create = var.delete_default_internet_gateway_routes
  mtu                             = var.mtu
}

// Shared VPC
resource "google_compute_shared_vpc_host_project" "shared_vpc_host" {
  count      = var.shared_vpc_host ? 1 : 0
  project    = var.project
  depends_on = [google_compute_network.network, null_resource.module_depends_on ]
}