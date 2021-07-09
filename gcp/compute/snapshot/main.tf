/**
  *
  * # Google Cloud Compute snapshot
  *
  * This module is used to create snapshot policy and attach disks to this policy.
  */
variable "module_depends_on" {
  default = [""]
}

resource "null_resource" "module_depends_on" {
  triggers = {
    value = length(var.module_depends_on)
  }
}

resource "google_compute_resource_policy" "snapshot_policy" {
  name = "${var.policy_name_prefix}-snapshot-policy"
  region = "${element(split("-", var.location),0)}-${element(split("-", var.location),1)}"

  snapshot_schedule_policy {

    schedule {
      dynamic "hourly_schedule" {
        for_each = [for s in var.hourly_schedule: {
          hours_in_cycle = s.hours_in_cycle
          start_time = s.start_time
        }]
        content {
          hours_in_cycle = hourly_schedule.value.hours_in_cycle
          start_time = hourly_schedule.value.start_time
        }
      }

      dynamic "daily_schedule" {
        for_each = [for s in var.daily_schedule: {
          days_in_cycle = s.days_in_cycle
          start_time = s.start_time
        }]
        content {
          days_in_cycle = daily_schedule.value.days_in_cycle
          start_time = daily_schedule.value.start_time
        }
      }

      dynamic "weekly_schedule" {
        for_each = [for s in var.weekly_schedule: {
          day = s.day
          start_time = s.start_time
        }]
        content {
          day_of_weeks {
            day = upper(weekly_schedule.value.day)
            start_time = weekly_schedule.value.start_time
          }
        }
      }

    }

    retention_policy {
      max_retention_days = var.max_retention_days
      on_source_disk_delete = upper(var.on_source_disk_delete)
    }

    snapshot_properties {
      labels = var.labels
      storage_locations = [ "${element(split("-", var.location),0)}-${element(split("-", var.location),1)}" ]
      guest_flush = var.guest_flush
    }
  }

}

resource "google_compute_disk_resource_policy_attachment" "attachement" {
  count = length(var.disks_to_attach)

  disk = var.disks_to_attach[count.index]
  name = google_compute_resource_policy.snapshot_policy.name

  zone = var.location

  depends_on                       = [ null_resource.module_depends_on]
}