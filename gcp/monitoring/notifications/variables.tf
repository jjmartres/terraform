variable "project" {
  type = string
  description = "The default project to manage resources in"
}

variable notification_name {
  type        = string
  description = "An optional human-readable name for this notification channel. It is recommended that you specify a non-empty and unique name in order to make it easier to identify the channels in your project, though this is not enforced. The display name is limited to 512 Unicode characters."
}

variable notification_group_email {
  type        = string
  description = "Email of the group to notify"
  default     = ""
}

variable notification_slack_channel {
  type        = string
  description = "The slack channel to notify"
  default     = ""
}

variable project_id_slack_token {
  type        = string
  description = "`project_id` where an authorization token for a notification channel is stored"
  default     = ""
}

variable "secret_id" {
  type = string
  description = "This must be the unique `secret_id` within the project."
}

variable "module_depends_on" {
  description = "List of modules or resources this module depends on."
  type        = list(any)
  default     = []
}