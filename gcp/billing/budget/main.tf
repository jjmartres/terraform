/**
  *
  * # Google Cloud billing budget
  *
  * This module allows the creation of a google billing budget tied to a specific project_id
  */
locals {
  project_name     = length(var.projects) == 0 ? "All Projects" : var.projects[0]
  display_name     = var.display_name == null ? "Budget For ${local.project_name}" : var.display_name
  all_updates_rule = var.alert_pubsub_topic == null && length(var.monitoring_notification_channels) == 0 ? [] : ["1"]

  projects = length(var.projects) == 0 ? null : [
  for project in data.google_project.project :
  "projects/${project.number}"
  ]
  services = var.services == null ? null : [
  for id in var.services :
  "services/${id}"
  ]
}

data "google_project" "project" {
  depends_on = [var.projects]
  count      = length(var.projects)
  project_id = element(var.projects, count.index)
}

resource "google_billing_budget" "budget" {
  provider = google-beta
  count    = var.create_budget ? 1 : 0

  billing_account = var.billing_account
  display_name    = local.display_name

  budget_filter {
    projects               = local.projects
    credit_types_treatment = var.credit_types_treatment
    services               = local.services
  }

  amount {
    specified_amount {
      units = tostring(var.amount)
    }
  }

  dynamic "threshold_rules" {
    for_each = var.alert_spent_percents
    content {
      threshold_percent = threshold_rules.value
    }
  }

  dynamic "all_updates_rule" {
    for_each = local.all_updates_rule
    content {
      pubsub_topic                     = var.alert_pubsub_topic
      monitoring_notification_channels = var.monitoring_notification_channels
    }
  }
}