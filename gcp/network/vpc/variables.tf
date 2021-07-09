variable "project" {
  type        = string
  description = "The project ID to manage the Cloud SQL resources"
}

variable "location" {
  type = string
  description = "The location (region or zone) in which the instance will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the instance will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well"
}

variable "network_name" {
  type        = string
  description = "The name of the network being created"
}

variable "routing_mode" {
  type        = string
  description = "The network routing mode (default `GLOBAL`). Possible values are `REGIONAL` or `GLOBAL`"
  default     = "GLOBAL"
}

variable "shared_vpc_host" {
  type        = bool
  description = "Makes this project a Shared VPC host if true (default false)"
  default     = false
}

variable "description" {
  type        = string
  description = "An optional description of this resource. The resource must be recreated to modify this field."
  default     = ""
}

variable "auto_create_subnetworks" {
  type        = bool
  description = "When set to true, the network is created in auto subnet mode and it will create a subnet for each region automatically across the `10.128.0.0/9` address range. When set to false, the network is created in custom subnet mode so the user can explicitly connect subnetwork resources."
  default     = false
}

variable "delete_default_internet_gateway_routes" {
  type        = bool
  description = "If set, ensure that all routes within the network specified whose names begin with `default-route` and with a next hop of `default-internet-gateway` are deleted"
  default     = false
}

variable "mtu" {
  type        = number
  description = "The network MTU. Must be a value between `1460` and `1500` inclusive. If set to 0 (meaning MTU is unset), the network will default to `1460` automatically."
  default     = 1460
}

variable "module_depends_on" {
  description = "List of modules or resources this module depends on."
  type        = list(any)
  default     = []
}