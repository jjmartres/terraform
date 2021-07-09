variable "name" {
  type = string
  description = "(Required) Name of Datadog synthetics test"
}

variable "status" {
  type = string
  description = "(Required) Status of the synthetics test. Can be `live` or `paused`"
  default = "live"
}

variable "tags" {
  type = list(string)
  description = "(Required) A list of tags to associate with your synthetics test. This can help you categorize and filter tests in the manage synthetics page of the UI"
}

variable "host" {
  type = string
  description = "(Required) Hostname to request SSL validity"
}

variable "port" {
  type = number
  description = "(Required) Port of the hostname to request SSL validity"
  default = 443
}

variable "operator" {
  type = string
  description = "Operator used to check SSL validity. Can be `isInMoreThan` or `isInLessThan`"
  default = "isInLessThan"
}

variable "period" {
  type = number
  description = "Number of days until SSL certificate expire"
  default = 30
}

variable "locations" {
  type = list(string)
  description = "(Required) List of Datadog locations where test are executed. Please refer to Datadog documentation for available locations: https://docs.datadoghq.com/fr/api/?lang=bash#get-available-locations"
}

variable "message" {
  type = string
  description = "(Required) A message to include with notifications for this synthetics test. Email notifications can be sent to specific users by using the same `@username` notation as events."
}

variable "tick_every" {
  type = number
  description = "(Required) How often the test should run (in seconds). Current possible values are 900, 1800, 3600, 21600, 43200, 86400, 604800"
  default = 1800
}

variable "accept_self_signed" {
  type = bool
  description = "Accept or not SSL self signed certificates"
  default = false
}

variable "min_failure_duration" {
  type = number
  description = "How long the test should be in failure before alerting (integer, number of seconds, max 7200)"
  default = 0
}

variable "min_location_failed" {
  type = number
  description = "Threshold below which a synthetics test is allowed to fail before sending notifications"
}