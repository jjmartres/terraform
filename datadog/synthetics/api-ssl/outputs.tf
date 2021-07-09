output "attributes" {
  description = "Information about the synthetics test resource"
  value = map(
  "id", datadog_synthetics_test.ssl.id,
  "monitor_id", datadog_synthetics_test.ssl.monitor_id,
  "type", datadog_synthetics_test.ssl.type,
  "subtype", datadog_synthetics_test.ssl.subtype,
  "name", datadog_synthetics_test.ssl.name
  )
}

output "locations" {
  description = "Locations where synthetics are run"
  value = datadog_synthetics_test.ssl.locations
}