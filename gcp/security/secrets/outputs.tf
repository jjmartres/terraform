output "id" {
  description = "Identifier for the secret. Format: `projects/{{project}}/secrets/{{secret_id}}`"
  value       = google_secret_manager_secret.secret.id
}

output "name" {
  description = "The resource name of the Secret. Format: `projects/{{project}}/secrets/{{secret_id}}`"
  value       = google_secret_manager_secret.secret.name
}

output "version" {
  description = "The resource name of the SecretVersion. Format: `projects/{{project}}/secrets/{{secret_id}}/versions/{{version}}`"
  value       = google_secret_manager_secret_version.secret.name
}
