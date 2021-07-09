## Global variables
##
variable "project" {
  type = string
  description = "The default project to manage resources in."
}

variable "project_description" {
  type = string
  description = "A brief description of the resource. It will be use as a description of each resources"
}

variable "location" {
  type = string
  description = "The location (region or zone) in which the cluster master will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well."
}

## Firewall rule related variables
##

variable "name" {
  type  = string
  description = "(Required) Name of the firewall rule. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash."
}

variable "description" {
  type  = string
  description = "A short description of the rule"
  default = ""
}

variable "direction" {
  type  = string
  description = "Direction of traffic to which this firewall applies; default is INGRESS. Note: For INGRESS traffic, it is NOT supported to specify destinationRanges; For EGRESS traffic, it is NOT supported to specify sourceRanges OR sourceTags."
  default = "ingress"
}

variable "disabled" {
  type  = bool
  description = "Denotes whether the firewall rule is disabled, i.e not applied to the network it is associated with. When set to true, the firewall rule is not enforced and the network behaves as if it did not exist. If this is unspecified, the firewall rule will be enabled."
  default = false
}

variable "log_config" {
  type = string
  description = "This field denotes the logging options for a particular firewall rule. If defined, logging is enabled, and logs will be exported to Cloud Logging. Possible values are EXCLUDE_ALL_METADATA and INCLUDE_ALL_METADATA"
  default = "EXCLUDE_ALL_METADATA"
}

variable "priority" {
  type = number
  description = "Priority for the rule. This is an integer between 0 and 65535, both inclusive. When not specified, the value assumed is 1000. Relative priorities determine precedence of conflicting rules. Lower value of priority implies higher precedence (eg, a rule with priority 0 has higher precedence than a rule with priority 1). DENY rules take precedence over ALLOW rules having equal priority."
  default = 1000
}

variable "source_ranges" {
  type = list(string)
  description = "If specified, the firewall will apply only to traffic that has source IP address in these ranges. These ranges must be expressed in CIDR format. One or both of sourceRanges and sourceTags may be set. If both properties are set, the firewall will apply to traffic that has source IP address within sourceRanges OR the source IP that belongs to a tag listed in the sourceTags property. The connection does not need to match both properties for the firewall to apply. Only IPv4 is supported."
  default = []
}

variable "source_tags" {
  type = list(string)
  description = "If specified, the firewall will apply only to traffic with source IP that belongs to a tag listed in source tags. Source tags cannot be used to control traffic to an instance's external IP address. Because tags are associated with an instance, not an IP address. One or both of sourceRanges and sourceTags may be set. If both properties are set, the firewall will apply to traffic that has source IP address within sourceRanges OR the source IP that belongs to a tag listed in the sourceTags property. The connection does not need to match both properties for the firewall to apply."
  default = []
}

variable "target_tags" {
  type = list(string)
  description = "A list of instance tags indicating sets of instances located in the network that may make network connections as specified in allowed[]. If no targetTags are specified, the firewall rule applies to all instances on the specified network."
  default = []
}

variable "rules" {
  type = list(object({ protocol = string, ports = list(string)}))
  description = <<EOT
  Create and manage rules. For each rules, following arguments are supported:
    - protocol: (Required) The IP protocol to which this rule applies. The protocol type is required when creating a firewall rule. This value can either be one of the following well known protocol strings (tcp, udp, icmp, esp, ah, sctp), or the IP protocol number.
    - port: (Optional) An optional list of ports to which this rule applies. This field is only applicable for UDP or TCP protocol. Each entry must be either an integer or a range. If not specified, this rule applies to connections through any port. Example inputs include: ["22"], ["80","443"], and ["12345-12349"].
  EOT
  default = [ {  protocol = "TCP", ports = ["22"] } ]
}

## Network inerface related variables
##
variable "network" {
  type = string
  description = "The name or self_link of the network to attach this firewall to"
  default = "default"
}

