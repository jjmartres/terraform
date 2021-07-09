/**
  *
  * # Google Cloud Kubernetes Engine a.k.a. GKE
  *
  * This module is used to create an manage Google Kubernetes Cluster
  */
resource "google_container_cluster" "cluster" {
  provider = google
  name     = var.name
  location = var.location
  description = var.description

  # As we can't create a cluster with no node pool defined, but we want to only use separately managed node pools. So we create the smallest possible default node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count = 1
  node_version = var.kubernetes_version
  min_master_version = var.kubernetes_version

  network = var.network
  subnetwork = var.subnetwork

  master_auth {
    username = ""
    password = ""

    client_certificate_config {

      issue_client_certificate = false
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = var.maintenance_window
    }
  }
}

resource "google_container_node_pool" "node_pools" {
  cluster    = google_container_cluster.cluster.name

  count = var.node_pools
  name = "${element(split("-", var.name),0)}-${format("%03d", count.index + 1)}"

  location   = var.location
  node_count = var.initial_node_count

  version = var.kubernetes_version

  node_config {
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb
    disk_type = var.disk_type
    tags = var.tags

    labels = lookup(var.labels, "${element(split("-", var.name),0)}-${format("%03d", count.index + 1)}", null)

    metadata = {
      disable-legacy-endpoints = "true"
    }
    service_account = var.service_account

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  management {
    auto_repair = var.auto_repair
    auto_upgrade = var.auto_upgrade
  }

  autoscaling {
    max_node_count = var.max_node_count
    min_node_count = var.min_node_count
  }

  timeouts {
    create = "${var.create_timeout}m"
    update = "${var.update_timeout}m"
    delete = "${var.delete_timeout}m"
  }
}