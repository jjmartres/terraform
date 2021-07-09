variable "project_id" {
  type = string
  description = "(Required) Your Google Cloud project ID found in your JSON service account key"
}

variable "private_key_id" {
  type = string
  description = "(Required) Your private key ID found in your JSON service account key"
}

variable "private_key" {
  type = string
  description = "(Required) Your private key name found in your JSON service account key"
}

variable "client_email" {
  type = string
  description = "(Required) Your email found in your JSON service account key"
}

variable "client_id" {
  type = string
  description = "(Required) Your ID found in your JSON service account key"
}

variable "host_filters" {
  type = string
  description = "(Optional) Limit the GCE instances that are pulled into Datadog by using tags. Only hosts that match one of the defined tags are imported into Datadog."
}