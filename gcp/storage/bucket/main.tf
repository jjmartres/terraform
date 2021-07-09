/*
 * # Google Cloud Storage Buckets
 *
 * This module is used to create Google Cloud Storage buckets.
 *
*/
resource "random_id" "random_string" {
  byte_length = 2
}

locals {
  bucket_name         = var.name == "" ? format("%s-%s", var.project, random_id.random_string.dec) : var.name
  has_cors            = length(var.cors_origins) > 0 || length(var.cors_methods) > 0 || length(var.cors_response_headers) > 0
  has_predefined_acl  = var.predefined_acl != "" && ! var.uniform_bucket_level_access
  has_role_entity_acl = length(var.role_entity) > 0 && ! var.uniform_bucket_level_access
}

resource "google_storage_bucket" "bucket" {
  name               = local.bucket_name
  project            = var.project
  location           = var.location
  storage_class      = upper(var.storage_class)
  force_destroy      = var.force_destroy
  labels             = var.labels
  uniform_bucket_level_access = var.uniform_bucket_level_access

  versioning {
    enabled = var.versioning_enabled
  }

  dynamic "logging" {
    for_each = var.log_bucket == "" ? [] : [1]
    content {
      log_bucket        = var.log_bucket
      log_object_prefix = var.log_object_prefix
    }
  }

  dynamic "encryption" {
    for_each = var.kms_key_sl == "" ? [] : [1]
    content {
      default_kms_key_name = var.kms_key_sl
    }
  }

  dynamic "retention_policy" {
    for_each = var.retention_policy_retention_period == "" ? [] : [1]
    content {
      is_locked        = var.retention_policy_is_locked
      retention_period = var.retention_policy_retention_period
    }
  }

  dynamic "website" {
    for_each = var.website_main_page_suffix == "" ? [] : [1]
    content {
      main_page_suffix = var.website_main_page_suffix
      not_found_page   = var.website_not_found_page
    }
  }

  dynamic "cors" {
    for_each = local.has_cors ? [1] : []
    content {
      origin          = var.cors_origins
      method          = var.cors_methods
      response_header = var.cors_response_headers
      max_age_seconds = var.cors_max_age_seconds
    }
  }

  //noinspection HILUnresolvedReference
  dynamic "lifecycle_rule" {
    for_each = [for rule in var.lifecycle_rules : {
      action_type          = rule.action.type
      action_storage_class = lookup(rule.action, "storage_class", null)

      condition_age                   = lookup(rule.condition, "age", null)
      condition_created_before        = lookup(rule.condition, "created_before", null)
      condition_with_state            = lookup(rule.condition, "with_state", null)
      condition_matches_storage_class = lookup(rule.condition, "matches_storage_class", null)
      condition_num_newer_versions    = lookup(rule.condition, "num_newer_versions", null)
    }]

    content {
      action {
        type          = lifecycle_rule.value.action_type
        storage_class = lifecycle_rule.value.action_storage_class
      }
      condition {
        age                   = lifecycle_rule.value.condition_age
        created_before        = lifecycle_rule.value.condition_created_before
        with_state            = lifecycle_rule.value.condition_with_state
        matches_storage_class = lifecycle_rule.value.condition_matches_storage_class
        num_newer_versions    = lifecycle_rule.value.condition_num_newer_versions
      }
    }
  }
}

resource "google_storage_bucket_acl" "with_predefined_acl" {
  count          = local.has_predefined_acl == true ? 1 : 0
  bucket         = google_storage_bucket.bucket.name
  default_acl    = var.default_acl
  predefined_acl = var.predefined_acl
}

resource "google_storage_bucket_acl" "with_role_entity" {
  count       = local.has_role_entity_acl == true ? 1 : 0
  bucket      = google_storage_bucket.bucket.name
  default_acl = var.default_acl
  role_entity = var.role_entity
}

resource "google_compute_backend_bucket" "backend" {
  count = var.enable_backend_bucket != null ? 1 : 0
  project = var.project
  bucket_name = google_storage_bucket.bucket.name
  description = "Backend bucket of ${google_storage_bucket.bucket.name}"
  name = "backend-${google_storage_bucket.bucket.name}"
  enable_cdn = var.enable_cdn
}