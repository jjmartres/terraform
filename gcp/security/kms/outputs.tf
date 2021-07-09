output "keyring" {
  description = "Self link of the keyring."
  value       = google_kms_key_ring.key_ring.self_link
}

output "keyring_resource" {
  description = "Keyring resource."
  value       = google_kms_key_ring.key_ring
}

output "keys" {
  description = "Map of key name => key self link."
  value       = local.keys_by_name
}

output "keyring_name" {
  description = "Name of the keyring."
  value       = google_kms_key_ring.key_ring.name
}