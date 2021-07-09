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

variable "ports" {
  type        = list(string)
  description = "(Required) List of ports (or port ranges) to forward to backend services. Max is `5`."
}

variable "health_check_port" {
  type        = number
  description = "(Required) Port to perform health checks on."
}

variable "backends" {
  type        = list(map(string))
  description = <<EOD
  (Required) List of backends, should be a map of key-value pairs for each backend, must have the 'group' key."

  Example:
  ```backends = [
    {
      description = "Sample Instance Group for Internal LB",
      group       = "The fully-qualified URL of an Instance Group"
    }
  ]
  ```
  EOD
}

variable "network" {
  type        = string
  description = "(Optional) Self link of the VPC network in which to deploy the resources."
  default     = "default"
}

variable "subnetwork" {
  type        = string
  description = "(Optional) Self link of the VPC subnetwork in which to deploy the resources."
  default     = ""
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

variable "service_label" {
  type        = string
  description = "(Optional) An optional prefix to the service name for this Forwarding Rule. If specified, will be the first label of the fully qualified service name."
  default     = ""
}

variable "network_project" {
  type        = string
  description = "(Optional) The name of the GCP Project where the network is located. Useful when using networks shared between projects. If empty, var.project will be used."
  default     = ""
}

variable "http_health_check" {
  type        = bool
  description = "(Optional) Set to true if health check is type http, otherwise health check is tcp."
  default     = false
}

variable "session_affinity" {
  type        = string
  description = "(Optional) The session affinity for the backends, e.g.: `NONE`, `CLIENT_IP`. Default is `NONE`."
  default     = "NONE"
}

variable "source_tags" {
  type        = list(string)
  description = "(Optional) List of source tags for traffic between the internal load balancer."
  default     = []
}

variable "target_tags" {
  type        = list(string)
  description = "(Optional) List of target tags for traffic between the internal load balancer."
  default     = []
}

variable "custom_labels" {
  type        = map(string)
  description = "(Optional) A map of custom labels to apply to the resources. The key is the label name and the value is the label value."
  default     = {}
}