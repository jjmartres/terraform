variable "project" {
  type        = string
  description = "The project ID to manage the resources"
}

variable "location" {
  type = string
  description = "The location (region or zone) in which the resource will be created."
}

variable "id" {
  type = string
  description = "This must be unique within the project."
}

variable "data" {
  type = string
  description = "The secret data. Must be no larger than `64KiB`. This property is sensitive and will not be displayed in the plan."
}

variable "labels" {
  description = "The key/value labels for the resource."
  type        = map(string)
  default     = {}
}