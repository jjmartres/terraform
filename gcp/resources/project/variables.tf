variable "name" {
  type = string
  description = "(Required) The display name of the project"
}

variable "org_id" {
  type = string
  description = "(Optional) The numeric ID of the organization this project belongs to. Changing this forces a new project to be created. Only one of org_id or folder_id may be specified. If the org_id is specified then the project is created at the top level. Changing this forces the project to be migrated to the newly specified organization."
}

variable "folder_id" {
  type = string
  description = "(Optional) The numeric ID of the folder this project should be created under. Only one of org_id or folder_id may be specified. If the folder_id is specified, then the project is created under the specified folder. Changing this forces the project to be migrated to the newly specified folder."
  default     = ""
}

variable "billing_account" {
  type = string
  description = "(Optional) The alphanumeric ID of the billing account this project belongs to. The user or service account performing this operation with Terraform must have Billing Account Administrator privileges (roles/billing.admin) in the organization. See Google Cloud Billing API Access Control for more details."
}

variable "skip_delete" {
  type = bool
  description = "(Optional) If true, the Terraform resource can be deleted without deleting the Project via the Google API."
  default     = false
}

variable "auto_create_network" {
  type = bool
  description = "(Optional) Create the 'default' network automatically. Default true. If set to false, the default network will be deleted. Note that, for quota purposes, you will still need to have 1 network slot available to create the project successfully, even if you set auto_create_network to false, since the network will exist momentarily."
  default     = true
}

variable "default_region" {
  type = string
  description = "(Optional) The region used by default to create new resources"
  default     = ""
}

variable "default_zone" {
  type = string
  description = "(Optional) The zone within a region used by default to create new resources"
  default     = ""
}

variable "api_services" {
  type        = list(string)
  description = "(Optional) List of Google APIs to activate on this project"
  default     = []
}

variable "iam_bindings" {
  type        = map(list(string))
  description = "(Optional) Updates the IAM policy to grant a role to a list of members. Authoritative for a given role. Other roles within the IAM policy for the project are preserved."
  default     = {}
}

variable "enable_oslogin" {
  type = bool
  description = "Use Cloud OS Login API to manage OS login configuration for Google account users"
  default     = false
}