## Global variables
##
variable "project" {
  type = string
  description = "The default project to manage resources in."
}

variable "project_description" {
  type = string
  description = "A brief description of the resource. It will be use as a description of each resources"
}

variable "location" {
  type = string
  description = "The location (region or zone) in which the cluster master will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well."
}

## Instances related variables
##
variable "instances_count" {
  type = number
  description = "Number of instances to create."
  default = 1
}

variable "instances_name_prefix" {
  type = string
  description = "The prefix used to name instance(s). For example: prod-sql"
  default = "node"
}

variable "machine_type" {
  type = string
  description = "Type of the node compute engines."
  default = "n1-standard-4"
}

variable "instances_tags" {
  type = list(string)
  description = "Tags associated with instances."
  default = [
    "infrastructure",
    "terraform"]
}

## Boot disk related variables
##
variable "auto_delete" {
  type = bool
  description = "Whether the disk will be auto-deleted when the instance is deleted."
  default = true
}

variable "image_name" {
  type = string
  description = "Operating system images to create boot disks for the instance"
  default = "ubuntu-1804-lts"
}

variable "disk_size_gb" {
  type = number
  description = "Size of the instance disk."
  default = 80
}

variable "disk_type" {
  type = string
  description = "The GCE disk type. One of pd-standard or pd-ssd."
  default = "pd-standard"
}

## Network inerface related variables
##
variable "network" {
  type = string
  description = "The VPC network to host the instances in"
  default = "default"
}

## Startup script
##
variable "startup_script" {
  type = string
  description = "An alternative to using the startup-script metadata key, except this one forces the instance to be recreated (thus re-running the script) if it is changed. This replaces the startup-script metadata key on the created instance and thus the two mechanisms are not allowed to be used simultaneously."
  default = null
}