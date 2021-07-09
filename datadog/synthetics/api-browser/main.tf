/**
  *
  * # Datadog synthetics browser test
  *
  * This module is used to create and manage Datadog synthetics browser test
  */
locals {
  tags = var.tags != null ? concat(["terraform"], var.tags) : var.tags
}

resource "datadog_synthetics_test" "browser" {
  type = "browser"
  subtype = "http"
  name = var.name
  status = var.status
  tags = local.tags
  request = {
    method = var.method
    url = var.url
    body = var.body
  }
  devices_ids = var.devices
  locations = var.locations

  message = var.message

  options = {
    tick_every = var.tick_every
    min_failure_duration = var.min_failure_duration
    min_location_failed = var.min_location_failed
  }
}