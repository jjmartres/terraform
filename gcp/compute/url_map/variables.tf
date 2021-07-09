## Global variables
##
variable "project" {
  type = string
  description = "(Required) The default project to manage resources in."
}

variable "location" {
  type = string
  description = "(Required) The location (region or zone) in which the cluster master will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well."
}

variable "name" {
  type = string
  description = "(Required) Name of the resource. Provided by the client when the resource is created. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash."
}

variable "description" {
  type = string
  description = "(Optional) An optional description of this resource. Provide this property when you create the resource."
  default = ""
}

## url_map variables
##
variable "default_service" {
  type = string
  description = " (Optional) The backend service or backend bucket to use when none of the given rules match."
}

variable "rules" {
  type = list(object({
    hosts = list(string),
    path_matcher = string,
    description = string,
    default_service = string,
    path_rules = list(object({
      paths = list(string)
      service = string
    }))
  }))
  description = <<EOT
  (Optional) Rule to use against the URL:
    - `hosts`: (Required) The list of host patterns to match. They must be valid hostnames, except * will match any string of ([a-z0-9-.]*). In that case, * must be the first character and must be followed in the pattern by either - or ..
    - `path_matcher`: (Required) The name of the PathMatcher to use to match the path portion of the URL if the hostRule matches the URL's host portion.
    - `default_service`: (Optional) The backend service or backend bucket to use when none of the given paths match.
    - `paths`:  (Required) The list of path patterns to match. Each must start with / and the only place a is allowed is at the end following a /. The string fed to the path matcher does not include any text after the first ? or #, and those chars are not allowed here.
    - `service`: (Optional) The backend service or backend bucket to use if any of the given paths match.
    ```
    rules = [{
        hosts = ["mysite.com"],
        path_matcher = "mysite",
        default_service = "google_compute_backend_service.home.self_link"
        path_rules = [{
            "paths" = ["/home"],
            "service" = "google_compute_backend_service.home.self_link"
          },
          { "paths" = ["/login"],
            "service" = "google_compute_backend_service.login.self_link"
          },
          { "paths" = ["/static"],
            "service" = "google_compute_backend_service.static.self_link"
          }]
      }]
    ```
    EOT
  default = []
}