/**
  *
  * # Google Cloud Internal Load Balancer Module
  *
  * This Terraform Module creates an [Internal TCP/UDP Load Balancer](https://cloud.google.com/load-balancing/docs/internal/) using [internal forwarding rules](https://cloud.google.com/load-balancing/docs/internal/#forwarding_rule).
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
  region                = var.region
  network               = var.network == "" ? "default" : var.network
  subnetwork            = var.subnetwork
  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.default.self_link
  ip_address            = var.ip_address
  ip_protocol           = var.protocol
  ports                 = var.ports

  /* If service label is specified, it will be the first label of the fully qualified service name. */
  /* Due to the provider failing with an empty string, we're setting the name as service label default */
  service_label = var.service_label == "" ? var.name : var.service_label

  labels = var.custom_labels
}

resource "google_compute_region_backend_service" "default" {
  /* Create backen service */
  project          = var.project
  name             = var.name
  region           = "${element(split("-", var.location),0)}-${element(split("-", var.location),1)}"
  protocol         = var.protocol
  timeout_sec      = 10
  session_affinity = var.session_affinity

  dynamic "backend" {
    for_each = var.backends
    content {
      description = lookup(backend.value, "description", null)
      group       = lookup(backend.value, "group", null)
    }
  }

  health_checks = [
    compact(
      concat(
        google_compute_health_check.tcp.*.self_link,
        google_compute_health_check.http.*.self_link
      )
  )[0]]
}

resource "google_compute_health_check" "tcp" {
  /* Create health check - one of `http` or `tcp` */
  count = var.http_health_check ? 0 : 1

  project = var.project
  name    = "${var.name}-hc"

  tcp_health_check {
    port = var.health_check_port
  }
}

resource "google_compute_health_check" "http" {
  count = var.http_health_check ? 1 : 0

  project = var.project
  name    = "${var.name}-hc"

  http_health_check {
    port = var.health_check_port
  }
}

resource "google_compute_firewall" "load_balancer" {
  /* Create firewalls for the load balancer and health checks */
  /* Load balancer firewall allows ingress traffic from instances tagged with any of the ´var.source_tags´ */
  project = var.network_project == "" ? var.project : var.network_project
  name    = "${var.name}-ilb-fw"
  network = var.network

  allow {
    protocol = lower(var.protocol)
    ports    = var.ports
  }

  /* Source tags defines a source of traffic as coming from the primary internal IP address */
  /* of any instance having a matching network tag. */
  source_tags = var.source_tags

  /* Target tags define the instances to which the rule applies */
  target_tags = var.target_tags
}

resource "google_compute_firewall" "health_check" {
  /* Health check firewall allows ingress tcp traffic from the health check IP addresses */
  project = var.network_project == "" ? var.project : var.network_project
  name    = "${var.name}-hc"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = [var.health_check_port]
  }

  /* These IP ranges are required for health checks */
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]

  /* Target tags define the instances to which the rule applies */
  target_tags = var.target_tags
}
