## Global variables
##
variable "project" {
  type = string
  description = "The default project to manage resources in."
}

variable "location" {
  type = string
  description = "The location (region or zone) in which the cluster master will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well."
}

variable "policy_name_prefix" {
  type = string
  description = "The prefix used to name policy. For example: prod-sql"
  default = "policy"
}

## Scheduling parameters
##

variable "hourly_schedule" {
  type = list(object({  hours_in_cycle = number, start_time = string}))
  description = <<EOT
  (Optional) The policy will execute every nth hour starting at the specified time:
    - `hours_in_cycle`: (Required) The number of hours between snapshots.
    - `start_time`: (Required) Time within the window to start the operations. It must be in an hourly format "HH:MM", where HH : [00-23] and MM : [00] GMT. eg: 21:00.
  ```
  hourly_schedule = [{
      hours_in_cycle = 20
      start_time     = "23:00"
  }]
  ```
  EOT
  default = []
}

variable "daily_schedule" {
  type = list(object({  days_in_cycle = number, start_time = string}))
  description = <<EOT
  (Optional) The policy will execute every nth day at the specified time:
    - `days_in_cycle`: (Required) The number of days between snapshots.
    - `start_time`: (Required) This must be in UTC format that resolves to one of 00:00, 04:00, 08:00, 12:00, 16:00, or 20:00. For example, both 13:00-5 and 08:00 are valid.
  ```
  daily_schedule = [{
      days_in_cycle = 2
      start_time     = "04:00"
  }]
  ```
  EOT
  default = []
}

variable "weekly_schedule" {
  type = list(object({  day = string, start_time = string}))
  description = <<EOT
  (Optional) Allows specifying a snapshot time for each day of the week:
    - `day`: (Required) The day of the week to create the snapshot. e.g. MONDAY
    - `start_time`: (Required) Time within the window to start the operations. It must be in format "HH:MM", where HH : [00-23] and MM : [00-00] GMT.
  ```
  weekly_schedule = [{
    day = "monday",
    start_time = "04:00"
  }]
  ```
  EOT
  default = []
}

variable "max_retention_days" {
  type = number
  description = "(Required) Maximum age of the snapshot that is allowed to be kept."
  default = 7
}

variable "on_source_disk_delete" {
  type = string
  description = "(Optional) Specifies the behavior to apply to scheduled snapshots when the source disk is deleted. Valid options are `KEEP_AUTO_SNAPSHOTS` and `APPLY_RETENTION_POLICY`"
  default = "KEEP_AUTO_SNAPSHOTS"
}

variable "labels" {
  type = map(string)
  description = <<EOT
  (Optional) A set of key-value pairs
  ```
  labels ={
    key1 = "value1",
    key2 = "value2"
  }
  ```
  EOT
  default={ }
}

variable "guest_flush" {
  type = bool
  description = "(Optional) Whether to perform a `guest aware` snapshot."
  default = false
}

## Disks to associate to the policy
##
variable "disks_to_attach" {
  type = list(string)
  description = "(Required) The list of disks in which the resource policies are attached to."
  default = [ ]
}