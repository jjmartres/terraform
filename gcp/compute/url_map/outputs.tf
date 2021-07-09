output "self_link" {
  description = "The self link of the url_map created"
  value       = google_compute_url_map.url_map.self_link
}