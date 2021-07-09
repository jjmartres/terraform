output "cluster" {
  description = "Result is a map with cluster information"
  value = google_container_cluster.cluster
}

output "cluster_endpoint" {
  description = "The IP address of the cluster"
  value       = google_container_cluster.cluster.endpoint
}
