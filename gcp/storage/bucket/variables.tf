## Global variables
##
variable "project" {
  type = string
  description = "The default project id to manage resources in."
}

variable "location" {
  type = string
  description = "The GCS location. Please see: https://cloud.google.com/storage/docs/bucket-locations"
  default = "US"
}

## Bucket variables
##
variable "name" {
  type = string
  description = "The name of the bucket. If this is not supplied then a name will be generated for you using a combination of var.project and a random suffix. This approach to naming is in accordance with GCS bucket naming best practices, see: https://cloud.google.com/storage/docs/best-practices#naming."
  default = ""
}

variable "storage_class" {
  type = string
  description = "The storage class of the bucket. upported values include: `STANDARD`, `MULTI_REGIONAL`, `REGIONAL`, `NEARLINE`, `COLDLINE`. See: https://cloud.google.com/storage/docs/storage-classes"
  default = "STANDARD"
}

variable "default_acl" {
  type = string
  description = "The default ACL for the bucket, see: https://cloud.google.com/storage/docs/access-control/lists#predefined-acl."
  default = ""
}

variable "predefined_acl" {
  type = string
  description = "One of the canned bucket ACLs, see https://cloud.google.com/storage/docs/access-control/lists#predefined-acl for more details. Must be set if `var.role_entity` is not."
  default = ""
}
variable "role_entity" {
  type = list(any)
  description = "List of role/entity pairs in the form ROLE:entity. See https://cloud.google.com/storage/docs/json_api/v1/bucketAccessControls for more details. Must be set if `var.predefined_acl` is not."
  default = []
}

variable "force_destroy" {
  type = bool
  description = "When deleting a bucket, this boolean option will delete all contained objects. If you try to delete a bucket that contains objects, Terraform will fail that run."
  default = false
}

variable "labels" {
  type = map(any)
  description = "A set of key/value label pairs to assign to the bucket. See also:https://cloud.google.com/resource-manager/docs/creating-managing-labels#requirements."
  default = {}
}

variable "uniform_bucket_level_access" {
  type = bool
  description = "Enables Uniform bucket-level access access to a bucket."
  default = false
}

variable "log_bucket" {
  type = string
  description = "The name of the bucket to which access logs for this bucket should be written. If this is not supplied then no access logs are written."
  default = ""
}

variable "log_object_prefix" {
  type = string
  description = "The prefix for access log objects. If this is not provided then GCS defaults it to the name of the source bucket."
  default = ""
}

variable "kms_key_sl" {
  type = string
  description = "A `self_link` to a Cloud KMS key to be used to encrypt objects in this bucket, see also: https://cloud.google.com/storage/docs/encryption/using-customer-managed-keys. If this is not supplied then default encryption is used."
  default = ""
}

variable "versioning_enabled" {
  type = bool
  description = "If true then versioning is enabled for all objects in this bucket."
  default = false
}

variable "website_main_page_suffix" {
  type = string
  description = "The name of a file in the bucket which will act as the `index` page to be served by GCS if this bucket is hosting a static website. See also: https://cloud.google.com/storage/docs/hosting-static-website."
  default = ""
}
variable "website_not_found_page" {
  type = string
  description = "The name of the `not found` page to be served by GCS if this bucket is hosting a static website. See also: https://cloud.google.com/storage/docs/hosting-static-website."
  default = ""
}

variable "retention_policy_is_locked" {
  type = bool
  description = "If set to true, the bucket will be locked and any changes to the bucket's retention policy will be permanently restricted. Caution: Locking a bucket is an irreversible action."
  default = false
}
variable "retention_policy_retention_period" {
  type = string
  description = "The period of time, in seconds, that objects in the bucket must be retained and cannot be deleted, overwritten, or archived. The value must be less than `3,155,760,000 seconds`. If this is supplied then a bucket retention policy will be created."
  default = ""
}

variable "lifecycle_rules" {
  type = list(any)
  description = "The lifecycle rules to be applied to this bucket. If this array is populated then each element in it will be applied as a lifecycle rule to this bucket. The structure of each element is described in detail here: https://www.terraform.io/docs/providers/google/r/storage_bucket.html#lifecycle_rule. See also: https://cloud.google.com/storage/docs/lifecycle#configuration."
  default = []
}

variable "cors_origins" {
  type = list(string)
  description = "The list of Origins eligible to receive CORS response headers. Note: `*` is permitted in the list of origins, and means 'any Origin'. See also: https://tools.ietf.org/html/rfc6454."
  default = []
}

variable "cors_methods" {
  type = list(string)
  description = "The list of HTTP methods on which to include CORS response headers, (GET, OPTIONS, POST, etc) Note: `*` is permitted in the list of methods, and means 'any method'."
  default = []
}

variable "cors_response_headers" {
  type = list(string)
  description = "The list of HTTP headers other than the simple response headers to give permission for the user-agent to share across domains."
  default = []
}

variable "cors_max_age_seconds" {
  type = number
  description = "The value, in seconds, to return in the Access-Control-Max-Age header used in preflight responses."
  default = 0
}

variable "enable_backend_bucket" {
  type = bool
  description = "If true, a backend associated to the created bucket will be defined"
  default = false
}

variable "enable_cdn" {
  type = bool
  description = "If true, enable Cloud CDN for backend bucket."
  default = true
}