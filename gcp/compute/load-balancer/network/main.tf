/**
  *
  * # Google Cloud Network Load Balancer Module
  *
  * This Terraform Module creates a [Network Load Balancer](https://cloud.google.com/load-balancing/docs/network/) using [forwarding rules](https://cloud.google.com/load-balancing/docs/network/#forwarding_rules) and [target pools](https://cloud.google.com/load-balancing/docs/network/#target_pools).
  *
  * Google Cloud Platform (GCP) Internal TCP/UDP Load Balancing distributes traffic among VM instances in the same region in a VPC network using a private, internal (RFC 1918) IP address.
  *
  * ## Core concepts
  *
  * - [What is Cloud Load Balancing](https://github.com/terraform/-/blob/master/gcp/compute/load-balancer/_docs/core-concepts.md#what-is-cloud-load-balancing)
  * - [HTTP(S) Load Balancer Terminology](https://github.com/terraform/-/blob/master/gcp/compute/load-balancer/_docs/core-concepts.md#https-load-balancer-terminology)
  * - [Cloud Load Balancing Documentation](https://cloud.google.com/load-balancing/)
  */
resource "google_compute_forwarding_rule" "default" {
  /* Create forwarding rule */
  provider              = google-beta
  project               = var.project
  name                  = var.name
  target                = google_compute_target_pool.default.self_link
  load_balancing_scheme = "EXTERNAL"
  port_range            = var.port_range
  ip_address            = var.ip_address
  ip_protocol           = var.protocol

  labels = var.custom_labels
}

resource "google_compute_target_pool" "default" {
  /* Create target pool */
  provider         = google-beta
  project          = var.project
  name             = "${var.name}-tp"
  region           = "${element(split("-", var.location),0)}-${element(split("-", var.location),1)}"
  session_affinity = var.session_affinity

  instances = var.instances

  health_checks = google_compute_http_health_check.default.*.name
}

resource "google_compute_http_health_check" "default" {
  /* Create health check */
  count = var.enable_health_check ? 1 : 0

  provider            = google-beta
  project             = var.project
  name                = "${var.name}-hc"
  request_path        = var.health_check_path
  port                = var.health_check_port
  check_interval_sec  = var.health_check_interval
  healthy_threshold   = var.health_check_healthy_threshold
  unhealthy_threshold = var.health_check_unhealthy_threshold
  timeout_sec         = var.health_check_timeout
}

resource "google_compute_firewall" "health_check" {
  /* Create firewall for the health checks */
  /* Health check firewall allows ingress tcp traffic from the health check IP addresses */
  count = var.enable_health_check ? 1 : 0

  provider = google-beta
  project  = var.network_project == null ? var.project : var.network_project
  name     = "${var.name}-hc-fw"
  network  = var.network

  allow {
    protocol = "tcp"
    ports    = [var.health_check_port]
  }

  /* These IP ranges are required for health checks */
  source_ranges = ["209.85.152.0/22", "209.85.204.0/22", "35.191.0.0/16"]

  /* Target tags define the instances to which the rule applies */
  target_tags = var.firewall_target_tags
}
