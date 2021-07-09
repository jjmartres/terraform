output "name" {
  description = "The name of the bucket created"
  value       = google_storage_bucket.bucket.name
}

output "self_link" {
  description = "The self link of the bucket created"
  value       = google_storage_bucket.bucket.self_link
}

output "url" {
  description = "The base URL of the bucket created, in the form `gs://<name>`"
  value       = google_storage_bucket.bucket.url
}

output "backend" {
  description = "The backend self_link of the created bucket"
  value       = google_compute_backend_bucket.backend.*.self_link
}