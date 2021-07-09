output notification_channels {
  description = "The list of notification channels"
  value       = flatten([google_monitoring_notification_channel.email.*.id, google_monitoring_notification_channel.slack_channel.*.id])
}