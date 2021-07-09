resource "google_sql_database" "default" {
  count      = var.enable_default_db ? 1 : 0
  name       = var.db_name
  project    = var.project
  instance   = google_sql_database_instance.default.name
  charset    = var.db_charset
  collation  = var.db_collation
  depends_on = [null_resource.module_depends_on, google_sql_database_instance.default]
}

resource "google_sql_database" "additional_databases" {
  for_each   = local.databases
  project    = var.project
  name       = each.value.name
  charset    = lookup(each.value, "charset", null)
  collation  = lookup(each.value, "collation", null)
  instance   = google_sql_database_instance.default.name
  depends_on = [null_resource.module_depends_on, google_sql_database_instance.default]
}
