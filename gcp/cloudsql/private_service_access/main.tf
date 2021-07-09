/**
  *
  * # Submodule for VPC peering Cloud SQL services
  *
  * [Private IP](https://cloud.google.com/sql/docs/mysql/private-ip) configurations require a special peering between your VPC network and a VPC managed by Google. The module supports creating such a peering.
  * It is sufficient to instantiate this module once for all MySQL/PostgreSQL instances that are connected to the same VPC.
  */
resource "null_resource" "module_depends_on" {
  triggers = {
    value = length(var.module_depends_on)
  }
}

// We define a VPC peering subnet that will be peered with the
// Cloud SQL instance network. The Cloud SQL instance will
// have a private IP within the provided range.
// https://cloud.google.com/vpc/docs/configure-private-services-access
resource "google_compute_global_address" "google-managed-services-range" {
  provider      = google-beta
  project       = var.project
  name          = var.name != "" ? var.name : "google-managed-services-${var.network}"
  purpose       = "VPC_PEERING"
  address       = var.address
  prefix_length = var.prefix_length
  ip_version    = upper(var.ip_version)
  labels        = merge({"terraform": true },var.labels)
  address_type  = "INTERNAL"
  network       = var.network

  depends_on = [null_resource.module_depends_on ]
}

# Creates the peering with the producer network.
resource "google_service_networking_connection" "private_service_access" {
  provider                = google-beta
  network                 = var.network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.google-managed-services-range.name]
}

resource "null_resource" "dependency_setter" {
  depends_on = [google_service_networking_connection.private_service_access]
}