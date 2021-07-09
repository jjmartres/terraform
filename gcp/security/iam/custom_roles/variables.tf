variable "project" {
  type        = string
  description = "The project ID to manage the Cloud SQL resources"
}

variable "location" {
  type = string
  description = "The location (region or zone) in which the instance will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the instance will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well"
}

variable "role_id" {
  type        = string
  description = "ID of the Custom Role."
}

variable "title" {
  type        = string
  description = "Human-readable title of the Custom Role, defaults to `role_id`."
  default     = ""
}

variable "base_roles" {
  type        = list(string)
  description = "List of base predefined roles to use to compose custom role."
  default     = []
}

variable "permissions" {
  type        = list(string)
  description = "IAM permissions assigned to Custom Role."
}

variable "excluded_permissions" {
  type        = list(string)
  description = "List of permissions to exclude from custom role."
  default     = []
}

variable "description" {
  type        = string
  description = "Description of Custom role."
  default     = ""
}

variable "stage" {
  type        = string
  description = "The current launch stage of the role. Defaults to GA."
  default     = "GA"
}

variable "target_id" {
  type        = string
  description = "Variable for project or organization ID."
}

variable "target_level" {
  type        = string
  description = "String variable to denote if custom role being created is at project or organization level."
  default     = "project"
}

variable "members" {
  description = "List of members to be added to custom role."
  type        = list(string)
}