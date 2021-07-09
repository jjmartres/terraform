## Global variables
##
variable "project" {
  type = string
  description = "(Required) The default project to manage resources in."
}

variable "location" {
  type = string
  description = "(Required) The location (region or zone) in which the cluster master will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well."
}

variable "name" {
  type        = string
  description = "(Required) Name for the load balancer forwarding rule and prefix for supporting resources."
}

variable "network" {
  type        = string
  description = "(Optional) Self link of the VPC network in which to deploy the resources."
  default     = "default"
}

variable "protocol" {
  type        = string
  description = "(Optional) The protocol for the backend and frontend forwarding rule. TCP or UDP."
  default     = "TCP"
}

variable "ip_address" {
  type        = string
  description = "(Optional) IP address of the load balancer. If empty, an IP address will be automatically assigned."
  default     = ""
}

variable "port_range" {
  type        = string
  description = "(Optional) Only packets addressed to ports in the specified range will be forwarded to target. If empty, all packets will be forwarded."
  default     = null
}

variable "enable_health_check" {
  type        = bool
  description = "(Optional) Flag to indicate if health check is enabled. If set to true, a firewall rule allowing health check probes is also created."
  default     = false
}

variable "health_check_port" {
  type        = number
  description = "(Optional) The TCP port number for the HTTP health check request."
  default     = 80
}

variable "health_check_healthy_threshold" {
  type        = number
  description = "(Optional) A so-far unhealthy instance will be marked healthy after this many consecutive successes. The default value is `2`."
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  type        = number
  description = "(Optional) A so-far healthy instance will be marked unhealthy after this many consecutive failures. The default value is `2`."
  default     = 2
}

variable "health_check_interval" {
  type        = number
  description = "(Optional) How often (in seconds) to send a health check. Default is `5`."
  default     = 5
}

variable "health_check_timeout" {
  description = "How long (in seconds) to wait before claiming failure. The default value is `5` seconds. It is invalid for `health_check_timeout` to have greater value than `health_check_interval`"
  type        = number
  default     = 5
}

variable "health_check_path" {
  type        = string
  description = "(Optional) The request path of the HTTP health check request. The default value is `/`."
  default     = "/"
}

variable "firewall_target_tags" {
  type        = list(string)
  description = "(Optional) List of target tags for the health check firewall rule."
  default     = []
}

variable "network_project" {
  type        = string
  description = "(Optional) The name of the GCP Project where the network is located. Useful when using networks shared between projects. If empty, `var.project` will be used."
  default     = null
}

variable "session_affinity" {
  type        = string
  description = "(Optional) The session affinity for the backends, e.g.: `NONE,` `CLIENT_IP`. Default is `NONE`."
  default     = "NONE"
}

variable "instances" {
  type        = list(string)
  description = "(Optional) List of self links to instances in the pool. Note that the instances need not exist at the time of target pool creation."
  default     = []
}

variable "custom_labels" {
  type        = map(string)
  description = "(Optional) A map of custom labels to apply to the resources. The key is the label name and the value is the label value."
  default     = {}
}