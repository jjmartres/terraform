## Global variables
##
variable "project" {
  type = string
  description = "The default project to manage resources in."
}

variable "location" {
  type = string
  description = "The location (region or zone) in which the cluster master will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well."
}

variable "name" {
  description = "Name for the load balancer forwarding rule and prefix for supporting resources."
  type        = string
}

variable "url_map" {
  description = "A reference (self_link) to the url_map resource to use."
  type        = string
}

variable "enable_ssl" {
  description = "Set to true to enable ssl. If set to 'true', you will also have to provide 'var.ssl_certificates'."
  type        = bool
  default     = false
}

variable "ssl_certificates" {
  description = "List of SSL cert self links. Required if 'enable_ssl' is 'true'."
  type        = list(string)
  default     = []
}

variable "enable_http" {
  description = "Set to true to enable plain http. Note that disabling http does not force SSL and/or redirect HTTP traffic. See https://issuetracker.google.com/issues/35904733"
  type        = bool
  default     = true
}

variable "create_dns_entries" {
  description = "If set to true, create a DNS A Record in Cloud DNS for each domain specified in 'custom_domain_names'."
  type        = bool
  default     = false
}

variable "custom_domain_names" {
  description = "List of custom domain names."
  type        = list(string)
  default     = []
}

variable "dns_managed_zone_name" {
  description = "The name of the Cloud DNS Managed Zone in which to create the DNS A Records specified in 'var.custom_domain_names'. Only used if 'var.create_dns_entries' is true."
  type        = string
  default     = "replace-me"
}

variable "dns_record_ttl" {
  description = "The time-to-live for the site A records (seconds)"
  type        = number
  default     = 300
}

variable "custom_labels" {
  description = "A map of custom labels to apply to the resources. The key is the label name and the value is the label value."
  type        = map(string)
  default     = {}
}