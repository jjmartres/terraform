variable "client_name" {
  description = "Client name/account used in naming"
  type        = string
}

variable "environment" {
  description = "Project environment"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure location for Servicebus."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

variable "extra_tags" {
  description = "Extra tags to add"
  type        = map(string)
  default     = {}
}

variable "servicebus_namespaces_queues" {
  type        = any
  description = "Map to handle Servicebus creation. It supports the creation of the queues, authorization_rule associated with each namespace you create"
}