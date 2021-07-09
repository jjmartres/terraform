/*
 * # Google Cloud project services
 *
 * This module is used to enable API services for an existing Google Cloud Platform project.
 *
*/
locals {
  required_api_services = [
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "serviceusage.googleapis.com",
  ]
  selected_api_services = distinct(
  concat(
  sort(local.required_api_services),
  sort(var.api_services)
  ),
  )
}

resource "google_project_service" "api_enabled" {
  count = length(local.selected_api_services)

  project = var.project_id
  service = local.selected_api_services[count.index]

  disable_on_destroy = false
}