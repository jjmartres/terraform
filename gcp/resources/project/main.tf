/*
 * # Google Cloud project
 *
 * This module is used to create an manage project for a specific Google Cloud Organization ID
 *
*/
resource "random_pet" "prefix" {
}

resource "random_id" "google_project_id" {
  byte_length = 4
  prefix = "${random_pet.prefix.id}-"
}

resource "google_project" "project" {
  name = var.name

  project_id = lower(random_id.google_project_id.hex)
  org_id = var.folder_id == "" ? var.org_id : null
  folder_id = var.folder_id != "" ? var.folder_id : null
  billing_account = var.billing_account
  skip_delete = var.skip_delete

  auto_create_network = var.auto_create_network
}

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

resource "google_project_iam_binding" "authoritative" {
  for_each = var.iam_bindings
  project = google_project.project.project_id
  role = each.key
  members = distinct(compact(each.value))
}

resource "google_project_service" "enabled" {
  count = length(local.selected_api_services)

  project = google_project.project.project_id
  service = local.selected_api_services[count.index]

  disable_on_destroy = false
}

resource "google_compute_project_metadata_item" "default_region" {
  count = var.default_region == "" ? 0 : 1
  depends_on = [
    google_project_service.enabled]

  project = google_project.project.project_id
  key = "google-compute-default-region"
  value = var.default_region
}

resource "google_compute_project_metadata_item" "default_zone" {
  count = var.default_zone == "" ? 0 : 1
  depends_on = [
    google_project_service.enabled]

  project = google_project.project.project_id
  key = "google-compute-default-zone"
  value = var.default_zone
}

resource "google_compute_project_metadata_item" "enable_oslogin" {
  depends_on = [
    google_project_service.enabled]

  project = google_project.project.project_id
  key = "enable-oslogin"
  value = contains(local.selected_api_services, "oslogin.googleapis.com") && var.enable_oslogin ? "TRUE" : "FALSE"
}