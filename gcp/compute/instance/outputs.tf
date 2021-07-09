output "workspace" {
  value = terraform.workspace
}

output "name_list" {
  description = "Result is a list of instance name"
  value = [
  for instance in google_compute_instance.instances:
  instance.name
  ]
}

output "instances" {
  description = "Result is a an array of map of instances and their name, id, public_ip, private_ip and self-link"
  value = [
  for instance in google_compute_instance.instances:
  map("name", instance.name, "id", instance.id, "public_ip", instance.network_interface[0].access_config[0].nat_ip, "private_ip", instance.network_interface[0].network_ip, "self-link", instance.self_link )
  ]
}