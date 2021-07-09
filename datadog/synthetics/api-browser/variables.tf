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

variable "method" {
  type = string
  description = "HTTP method verb: `DELETE`,`GET`,`HEAD`,`OPTIONS`,`PATCH`,`POST`,`PUT`"
}

variable "url" {
  type = string
  description = "(Required) Any URL"
}

variable "body" {
  type = string
  description = "Request body"
  default = ""
}

variable "locations" {
  type = list(string)
  description = "(Required) List of Datadog locations where test are executed. Please refer to Datadog documentation for available locations: https://docs.datadoghq.com/fr/api/?lang=bash#get-available-locations"
}

variable "devices" {
  type = list(string)
  description = "List of devices"
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

variable "min_failure_duration" {
  type = number
  description = "How long the test should be in failure before alerting (integer, number of seconds, max 7200)"
  default = 0
}

variable "min_location_failed" {
  type = number
  description = "Threshold below which a synthetics test is allowed to fail before sending notifications"
}