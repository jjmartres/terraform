/**
  *
  * # Google Cloud notification channels
  *
  * This module allows the creation of notification channels to a specific `project_id`
  */
resource "null_resource" "module_depends_on" {
  triggers = {
    value = length(var.module_depends_on)
  }
}

data "google_secret_manager_secret_version" "slack_token" {
  project = var.project_id_slack_token
  secret  = var.secret_id

  depends_on = [ null_resource.module_depends_on ]

}

resource "google_monitoring_notification_channel" "email" {
  count        = var.notification_group_email != "" ? 1 : 0
  project      = var.project
  display_name = var.notification_name
  type         = "email"
  labels = {
    email_address = var.notification_group_email
  }
}

resource "google_monitoring_notification_channel" "slack_channel" {
  count        = var.notification_slack_channel != "" ? 1 : 0
  project      = var.project
  display_name = var.notification_name
  type         = "slack"
  labels = {
    channel_name = var.notification_slack_channel
  }
  sensitive_labels {
    auth_token = data.google_secret_manager_secret_version.slack_token.secret_data
  }

  depends_on = [
    data.google_secret_manager_secret_version.slack_token
  ]
}