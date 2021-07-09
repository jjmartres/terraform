output "workspace" {
  value = terraform.workspace
}

output "rule" {
  description = "Result is a map with the id, name, creation_timestamp and self-link of the firewall rule"
  value = map("id", google_compute_firewall.compute_firewall_rule.id,
              "name", google_compute_firewall.compute_firewall_rule.name,
              "creation_timestamp", google_compute_firewall.compute_firewall_rule.creation_timestamp,
              "self-link", google_compute_firewall.compute_firewall_rule.self_link)
}