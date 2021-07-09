## Global variables
##
variable "project" {
  type = string
  description = "The default project to manage resources in"
}

variable "location" {
  type = string
  description = "The location (region or zone) in which the cluster master will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well"
}

variable "name" {
  type = string
  description = "(Required) The name of the cluster, unique within the project and location"
}

variable "description" {
  type = string
  description = "(Optional) Description of the cluster"
}

variable "network" {
  type = string
  description = "(Optional) The `name` or `self_link` of the Google Compute Engine network to which the cluster is connected. For Shared VPC, set this to the self link of the shared network"
  default = "default"
}

variable "subnetwork" {
  type = string
  description = "(Optional) The `name` or `self_link` of the Google Compute Engine subnetwork in which the cluster's instances are launched"
  default = "default"
}

variable "maintenance_window" {
  type = string
  description = "(Required) Time window specified for daily maintenance operations. Specify `start_time` in RFC3339 format HH:MM, where HH : [00-23] and MM : [00-59] GMT"
  default = "03:30"
}

variable "kubernetes_version" {
  type = string
  description = "Kubernetes version to use. If not defined, the default node version will be used"
}

variable "node_pools" {
  type = number
  description = "(Required) The number of nodes pools to create in the cluster"
  default = 3
}

variable "initial_node_count" {
  type = number
  description = "(Optional) The initial number of nodes for the pool. In regional or multi-zonal clusters, this is the number of nodes per zone. Changing this will force recreation of the resource"
}

variable "min_node_count" {
  type = number
  description = "(Required) Minimum number of nodes in the NodePool. Must be `>=0` and `<=`"
  default = 1
}

variable "max_node_count" {
  type = number
  description = "(Required) Maximum number of nodes in the NodePool. Must be `>= min_node_count`"
  default = 3
}

variable "machine_type" {
  type = string
  description = "(Optional) The name of a Google Compute Engine machine type"
  default = "n1-standard-1"
}

variable "disk_size_gb" {
  type = number
  description = "(Optional) Size of the disk attached to each node, specified in GB. The smallest allowed disk size is `10GB`"
  default = 100
}

variable "disk_type" {
  type = string
  description = "(Optional) Type of the disk attached to each node (e.g. `pd-standard` or `pd-ssd`)"
  default = "pd-standard"
}

variable "tags" {
  type = list(string)
  description = "(Optional) The list of instance tags applied to all nodes. Tags are used to identify valid sources or targets for network firewalls"
  default = []
}
variable "labels" {
  type = map(any)
  description = "The Kubernetes labels (key/value pairs) to be applied to each node."
  default = { }
}

variable "auto_repair" {
  type = bool
  description = "(Optional) Whether the nodes will be automatically repaired"
  default = true
}

variable "auto_upgrade" {
  type = bool
  description = "(Optional) Whether the nodes will be automatically upgraded"
  default = true
}

variable "create_timeout" {
  type = number
  description = "Timeout used for adding node pools"
  default = 30
}

variable "update_timeout" {
  type = number
  description = "Timeout used for updates to node pools"
  default = 30
}

variable "delete_timeout" {
  type = number
  description = "Timeout used for removing node pools"
  default = 30
}

variable "service_account" {
  type        = string
  description = "The service account to run nodes."
  default     = ""
}