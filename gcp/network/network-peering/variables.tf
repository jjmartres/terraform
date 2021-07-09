variable "project" {
  type        = string
  description = "The project ID to manage the Cloud SQL resources"
}

variable "location" {
  type = string
  description = "The location (region or zone) in which the instance will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the instance will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well"
}

variable "prefix" {
  description = "Name prefix for the network peerings"
  type        = string
  default     = "network-peering"
}

variable "local_network" {
  description = "Resource link of the network to add a peering to."
  type        = string
}

variable "peer_network" {
  description = "Resource link of the peer network."
  type        = string
}

variable "export_peer_custom_routes" {
  description = "Export custom routes to local network from peer network."
  type        = bool
  default     = false
}

variable "export_local_custom_routes" {
  description = "Export custom routes to peer network from local network."
  type        = bool
  default     = false
}

variable "export_peer_subnet_routes_with_public_ip" {
  description = "Export custom routes to local network from peer network (defaults to `false`; causes the Local Peering Connection to align with the [provider default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_peering#import_subnet_routes_with_public_ip), and the Remote Peering Connection to be opposite the provider default)."
  type        = bool
  default     = false
}

variable "export_local_subnet_routes_with_public_ip" {
  description = "Export custom routes to peer network from local network (defaults to `true`; causes the Local Peering Connection to align with the [provider default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_peering#export_subnet_routes_with_public_ip), and the Remote Peering Connection to be opposite the provider default)."
  type        = bool
  default     = true
}

variable "module_depends_on" {
  description = "List of modules or resources this module depends on."
  type        = list(any)
  default     = []
}