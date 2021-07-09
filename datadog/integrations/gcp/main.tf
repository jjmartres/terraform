/**
  *
  * # Datadog Google Cloud Platform integration resource
  *
  * This module is used to create and manage Google Cloud Platform integration into Datadog.
  */
resource "datadog_integration_gcp" "gcp_project_integration" {
  client_email = var.client_email
  client_id = var.client_id
  private_key = var.private_key
  private_key_id = var.private_key_id
  project_id = var.project_id
  host_filters = var.host_filters
}