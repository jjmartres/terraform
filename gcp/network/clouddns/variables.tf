variable "project" {
  type        = string
  description = "The project ID to manage the Cloud SQL resources"
}

variable "location" {
  type = string
  description = "The location (region or zone) in which the instance will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the instance will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well"
}

variable "domain" {
  description = "Zone domain, must end with a period."
  type        = string
}

variable "name" {
  description = "Zone name, must be unique within the project."
  type        = string
}

variable "private_visibility_config_networks" {
  description = "List of `VPC` self links that can see this zone."
  default     = []
  type        = list(string)
}

variable "target_name_server_addresses" {
  description = "List of target name servers for forwarding zone."
  default     = []
  type        = list(string)
}

variable "target_network" {
  description = "Peering network."
  default     = ""
}

variable "description" {
  description = "zone description (shown in console)"
  default     = "Managed by Terraform"
  type        = string
}

variable "type" {
  description = "Type of zone to create, valid values are `public`, `private`, `forwarding`, `peering`."
  default     = "private"
  type        = string
}

variable "dnssec_config" {
  description = "Object containing : kind, non_existence, state. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone.html#dnssec_config for futhers details"
  type        = any
  default     = {}
}

variable "labels" {
  type        = map(any)
  description = "A set of key/value label pairs to assign to this ManagedZone"
  default     = {}
}

variable "default_key_specs_key" {
  description = "Object containing default key signing specifications : `algorithm`, `key_length`, `key_type`, `kind`. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone.html#dnssec_config for futhers details"
  type        = any
  default     = {}
}

variable "default_key_specs_zone" {
  description = "Object containing default zone signing specifications : `algorithm`, `key_length`, `key_type`, `kind`. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone.html#dnssec_config for futhers details"
  type        = any
  default     = {}
}

###############################################################################
#                               record variables                              #
###############################################################################

variable "recordsets" {
  type = list(object({
    name    = string
    type    = string
    ttl     = number
    records = list(string)
  }))
  description = <<EOT
  List of DNS record objects to manage, in the standard terraform dns structure. Example:
  ```
  recordsets = [
    {
      name    = ""
      type    = "NS"
      ttl     = 300
      records = [
        "127.0.0.1",
      ]
    }
  ]
  ```
  EOT
  default     = []
}