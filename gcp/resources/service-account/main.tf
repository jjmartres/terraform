/*
 * # Google Cloud Service Accounts Terraform module
 *
 * This module allows easy creation of one or more service accounts, and granting them basic roles.
 *
 * The resources/services/activations/deletions that this module will create/trigger are:
 *
 * - one or more service accounts
 * - optional project-level IAM role bindings for each service account
 * - one optional billing IAM role binding per service account, at the organization or billing account level
 * - two optional organization-level IAM bindings per service account, to enable the service accounts to create and manage Shared VPC networks
 * - one optional service account key per service account
 *
*/
locals {
  account_billing       = var.grant_billing_role && var.billing_account_id != ""
  billing_admin         = var.grant_billing_role && var.billing_account_id == "" && var.org_id != ""
  org_admin             = var.grant_org_role && var.org_id != ""
  prefix                = var.prefix != "" ? "${var.prefix}-" : ""
  suffix                = var.suffix != "" ? "-${var.suffix}" : ""
  xpn                   = var.grant_xpn_roles && var.org_id != ""
  service_accounts_list = [for name in var.names : google_service_account.service_accounts[name]]
  emails_list           = [for account in local.service_accounts_list : account.email]
  iam_emails_list       = [for email in local.emails_list : "serviceAccount:${email}"]
  names                 = toset(var.names)
  name_role_pairs       = setproduct(local.names, toset(var.project_roles))
  project_roles_map_data = zipmap(
    [for pair in local.name_role_pairs : "${pair[0]}-${pair[1]}"],
    [for pair in local.name_role_pairs : {
      name = pair[0]
      role = pair[1]
    }]
  )
}

# create service accounts
resource "google_service_account" "service_accounts" {
  for_each     = local.names
  account_id   = "${local.prefix}${lower(each.value)}${local.suffix}"
  display_name = "Terraform-managed service account"
  project      = var.project_id
}

# common roles
resource "google_project_iam_member" "project-roles" {
  for_each = local.project_roles_map_data

  project = element(
    split(
      "=>",
      each.value.role
    ),
    0,
  )

  role = element(
    split(
      "=>",
      each.value.role
    ),
    1,
  )

  member = "serviceAccount:${google_service_account.service_accounts[each.value.name].email}"
}

# conditionally assign billing admin role at the org level
resource "google_organization_iam_member" "billing_admin" {
  for_each = local.billing_admin ? local.names : toset([])
  org_id   = var.org_id
  role     = "roles/billing.admin"
  member   = "serviceAccount:${google_service_account.service_accounts[each.value].email}"
}

# conditionally assign organization admin role at the org level
resource "google_organization_iam_member" "organization_admin" {
  for_each = local.org_admin ? local.names : toset([])
  org_id   = var.org_id
  role     = "roles/resourcemanager.organizationAdmin"
  member   = "serviceAccount:${google_service_account.service_accounts[each.value].email}"
}

# conditionally assign billing user role on a specific billing account
resource "google_billing_account_iam_member" "billing_user" {
  for_each           = local.account_billing ? local.names : toset([])
  billing_account_id = var.billing_account_id
  role               = "roles/billing.user"
  member             = "serviceAccount:${google_service_account.service_accounts[each.value].email}"
}

# conditionally assign roles for shared VPC
# ref: https://cloud.google.com/vpc/docs/shared-vpc

resource "google_organization_iam_member" "xpn_admin" {
  for_each = local.xpn ? local.names : toset([])
  org_id   = var.org_id
  role     = "roles/compute.xpnAdmin"
  member   = "serviceAccount:${google_service_account.service_accounts[each.value].email}"
}

resource "google_organization_iam_member" "organization_viewer" {
  for_each = local.xpn ? local.names : toset([])
  org_id   = var.org_id
  role     = "roles/resourcemanager.organizationViewer"
  member   = "serviceAccount:${google_service_account.service_accounts[each.value].email}"
}

# keys
resource "google_service_account_key" "keys" {
  for_each           = var.generate_keys ? local.names : toset([])
  service_account_id = google_service_account.service_accounts[each.value].email
}