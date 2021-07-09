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

## Security policy variables
##
variable "name" {
  type = string
  description = "(Required) The name of the security policy"
}

variable "description" {
  type = string
  description = "(Optional) An optional description of this security policy. Max size is `2048`."
}

variable "default_action" {
  type = string
  description = <<EOT
    (Required) The default action to take. Valid values:
        - `allow`: allow access to target
        - `deny(status)` : deny access to target, returns the HTTP response code specified (valid values are `403`, `404` and `502`)
  EOT
  default = "deny(502)"
}

variable "rules" {
  type = list(object({ action = string, priority = number, description = string, src_ip_ranges = list(string)}))
  description = <<EOT
  The set of rules that belong to this policy. For each rules, following arguments are supported:
    - `action`: (required) The action to take when rule match. Possible values are:
          - `allow`: allow access to target
          - `deny(status)` : deny access to target, returns the HTTP response code specified (valid values are 403, 404 and 502)
    - `priority`:  (Required) An unique positive integer indicating the priority of evaluation for a rule. Rules are evaluated from highest priority (lowest numerically) to lowest priority (highest numerically) in order.
    - `description`: (optional) An optional description of this rule. Max size is 64.
    - `src_ip_ranges`: (required) Set of IP addresses or ranges (IPV4 or IPV6) in CIDR notation to match against inbound traffic. There is a limit of 5 IP ranges per rule. A value of '*' matches all IPs (can be used to override the default behavior).

  Example:
    ```
    rule = [
      {
        action = "allow",
        priority = 1000,
        description = "My first rules",
        src_ip_ranges = [
          "1.1.1.1/32",
          "2.2.2.2/32"]
      }
    ]
    ```
  EOT
}