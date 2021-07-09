variable "project" {
  type        = string
  description = "The project ID to manage the Cloud SQL resources"
}

variable "location" {
  type = string
  description = "The location (region or zone) in which the instance will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the instance will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well"
}

variable "keyring" {
  description = "Keyring name."
  type        = string
}

variable "keys" {
  description = "Key names."
  type        = list(string)
  default     = []
}

variable "prevent_destroy" {
  description = "Set the prevent_destroy lifecycle attribute on keys."
  default     = true
}

variable "set_owners_for" {
  description = "Name of keys for which owners will be set."
  type        = list(string)
  default     = []
}

variable "owners" {
  description = "List of comma-separated owners for each key declared in `set_owners_for`."
  type        = list(string)
  default     = []
}

variable "set_encrypters_for" {
  description = "Name of keys for which encrypters will be set."
  type        = list(string)
  default     = []
}

variable "encrypters" {
  description = "List of comma-separated owners for each key declared in `set_encrypters_for`."
  type        = list(string)
  default     = []
}

variable "set_decrypters_for" {
  description = "Name of keys for which decrypters will be set."
  type        = list(string)
  default     = []
}

variable "decrypters" {
  description = "List of comma-separated owners for each key declared in `set_decrypters_for`."
  type        = list(string)
  default     = []
}

variable "key_rotation_period" {
  description = "Every time this period passes, generate a new `CryptoKeyVersion` and set it as the primary. The first rotation will take place after the specified period. The rotation period has the format of a decimal number with up to 9 fractional digits, followed by the letter `s` (seconds). It must be greater than a `day` (ie, `86400`)."
  type    = string
  default = "100000s"
}

variable "key_algorithm" {
  type        = string
  description = "The algorithm to use when creating a version based on this template. See the https://cloud.google.com/kms/docs/reference/rest/v1/CryptoKeyVersionAlgorithm for possible inputs."
  default     = "GOOGLE_SYMMETRIC_ENCRYPTION"
}

variable "key_protection_level" {
  type        = string
  description = "The protection level to use when creating a version based on this template. Default value: `SOFTWARE` Possible values: `SOFTWARE`, `HSM`"
  default     = "SOFTWARE"
}

variable "labels" {
  type        = map(string)
  description = "Labels, provided as a map"
  default     = {}
}