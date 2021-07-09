/**
  *
  * # Google Cloud HTTP(S) Load Balancer Module
  *
  * This Terraform Module creates an [HTTP(S) Cloud Load Balancer](https://cloud.google.com/load-balancing/docs/https/) using [global forwarding rules](https://cloud.google.com/load-balancing/docs/https/global-forwarding-rules).
  *
  * HTTP(S) load balancing can balance HTTP and HTTPS traffic across multiple backend instances, across multiple regions. Your entire app is available via a single global IP address, resulting in a simplified DNS setup. HTTP(S) load balancing is scalable, fault-tolerant, requires no pre-warming, and enables content-based load balancing.
  *
  * ## Core concepts
  *
  * - [What is Cloud Load Balancing](https://github.com/terraform/-/blob/master/gcp/compute/load-balancer/_docs/core-concepts.md#what-is-cloud-load-balancing)
  * - [HTTP(S) Load Balancer Terminology](https://github.com/terraform/-/blob/master/gcp/compute/load-balancer/_docs/core-concepts.md#https-load-balancer-terminology)
  * - [Cloud Load Balancing Documentation](https://cloud.google.com/load-balancing/)
  */
resource "google_compute_global_address" "default" {
  project      = var.project
  name         = "${var.name}-address"
  ip_version   = "IPV4"
  address_type = "EXTERNAL"
}

resource "google_compute_target_http_proxy" "http" {
  /* If plain http enabled, create forwarding rule and proxy */
  count   = var.enable_http ? 1 : 0
  project = var.project
  name    = "${var.name}-http-proxy"
  url_map = var.url_map
}

resource "google_compute_global_forwarding_rule" "http" {
  provider   = google-beta
  count      = var.enable_http ? 1 : 0
  project    = var.project
  name       = "${var.name}-http-rule"
  target     = google_compute_target_http_proxy.http[0].self_link
  ip_address = google_compute_global_address.default.address
  port_range = "80"

  depends_on = [google_compute_global_address.default]

  labels = var.custom_labels
}

resource "google_compute_global_forwarding_rule" "https" {
  /* If SSL enabled, create forwardinf rule and proxy */
  provider   = google-beta
  project    = var.project
  count      = var.enable_ssl ? 1 : 0
  name       = "${var.name}-https-rule"
  target     = google_compute_target_https_proxy.default[0].self_link
  ip_address = google_compute_global_address.default.address
  port_range = "443"
  depends_on = [google_compute_global_address.default]

  labels = var.custom_labels
}

resource "google_compute_target_https_proxy" "default" {
  project = var.project
  count   = var.enable_ssl ? 1 : 0
  name    = "${var.name}-https-proxy"
  url_map = var.url_map

  ssl_certificates = var.ssl_certificates
}

resource "google_dns_record_set" "dns" {
  /* If dns entry requested, create a record pointing to the public ip of the clb */
  project = var.project
  count   = var.create_dns_entries ? length(var.custom_domain_names) : 0

  name = "${element(var.custom_domain_names, count.index)}."
  type = "A"
  ttl  = var.dns_record_ttl

  managed_zone = var.dns_managed_zone_name

  rrdatas = [google_compute_global_address.default.address]
}