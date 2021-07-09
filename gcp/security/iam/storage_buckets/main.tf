/*
 * # Google Cloud Storage Bucket IAM
 *
 * This module is used is used to assign storage_bucket roles.
 *
*/
module "helper" {
  source               = "../helper"
  bindings             = var.bindings
  mode                 = var.mode
  entities             = var.storage_buckets
  conditional_bindings = var.conditional_bindings
}

resource "google_storage_bucket_iam_binding" "storage_bucket_iam_authoritative" {
  for_each = module.helper.set_authoritative
  bucket   = module.helper.bindings_authoritative[each.key].name
  role     = module.helper.bindings_authoritative[each.key].role
  members  = module.helper.bindings_authoritative[each.key].members
  dynamic "condition" {
    for_each = module.helper.bindings_authoritative[each.key].condition.title == "" ? [] : [module.helper.bindings_authoritative[each.key].condition]
    content {
      title       = module.helper.bindings_authoritative[each.key].condition.title
      description = module.helper.bindings_authoritative[each.key].condition.description
      expression  = module.helper.bindings_authoritative[each.key].condition.expression
    }
  }
}

resource "google_storage_bucket_iam_member" "storage_bucket_iam_additive" {
  for_each = module.helper.set_additive
  bucket   = module.helper.bindings_additive[each.key].name
  role     = module.helper.bindings_additive[each.key].role
  member   = module.helper.bindings_additive[each.key].member
  dynamic "condition" {
    for_each = module.helper.bindings_additive[each.key].condition.title == "" ? [] : [module.helper.bindings_additive[each.key].condition]
    content {
      title       = module.helper.bindings_additive[each.key].condition.title
      description = module.helper.bindings_additive[each.key].condition.description
      expression  = module.helper.bindings_additive[each.key].condition.expression
    }
  }
}