variable "project_id" {
  type = string
  description = "(Required) The project ID. If not provided, the provider project is used"
}

variable "api_services" {
  type        = list(string)
  description = "(Optional) List of Google APIs to activate on this project"
  default     = []
}