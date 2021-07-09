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

variable "subnets" {
  type        = list(map(string))
  description = "The list of subnets being created"
}

variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets"
  default     = {}
}

variable "module_depends_on" {
  description = "List of modules or resources this module depends on."
  type        = list(any)
  default     = []
}