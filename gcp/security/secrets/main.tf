/*
 * # Google Cloud Secret Manager
 *
 * A Secret is a logical secret whose value and versions can be accessed. This module will allow to manage secrets.
 *
*/
resource "google_secret_manager_secret" "secret" {
  secret_id = var.id
  labels = merge({"terraform": true },var.labels)
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "secret" {
  secret = google_secret_manager_secret.secret.id
  secret_data = var.data
}