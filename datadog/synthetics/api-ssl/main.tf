/**
  *
  * # Datadog synthetics SSL test
  *
  * This module is used to create and manage Datadog synthetics SSL test
  */
locals {
  tags = var.tags != null ? concat(["terraform"], var.tags) : var.tags
}

resource "datadog_synthetics_test" "ssl" {
  type = "api"
  subtype = "ssl"
  name = var.name
  status = var.status
  tags = local.tags
  request = {
    host = var.host
    port = var.port
  }
  assertions = [
    {
      type = "certificate"
      operator = var.operator
      target = var.period
    }
  ]
  message = var.message
  locations = var.locations
  options = {
    tick_every = var.tick_every
    accept_self_signed = var.accept_self_signed
    min_failure_duration = var.min_failure_duration
    min_location_failed = var.min_location_failed
  }
}