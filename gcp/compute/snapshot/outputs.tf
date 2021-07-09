output "snapshot_schedule_policy" {
  description = "The created schedule policy"
  value = google_compute_resource_policy.snapshot_policy.snapshot_schedule_policy
}

output "attached_disks" {
  description = "List of disk attached to the schedule policy"
  value = google_compute_disk_resource_policy_attachment.attachement
}