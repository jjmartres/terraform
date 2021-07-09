# Terraform CloudSQL modules

It makes it easy to create Google CloudSQL instance and implement high availability settings.
This module consists of the following submodules:

- [postgresql](postgresql/README.md)
- [private service access](private_service_access/README.md)

See more details in each module's README.

## Requirements

### Installation Dependencies

See more details in each module's README.

### Configure a Service Account

In order to execute this module you must have a Service Account with the following:

#### Roles

- Cloud SQL Admin: `roles/cloudsql.admin`
- Compute Network Admin: `roles/compute.networkAdmin`

### Enable APIs

In order to operate with the Service Account you must activate the following APIs on the project where the Service Account was created:

- Cloud SQL Admin API: `sqladmin.googleapis.com`

In order to use Private Service Access, required for using Private IPs, you must activate
the following APIs on the project where your VPC resides:

- Cloud SQL Admin API: `sqladmin.googleapis.com`
- Compute Engine API: `compute.googleapis.com`
- Service Networking API: `servicenetworking.googleapis.com`
- Cloud Resource Manager API: `cloudresourcemanager.googleapis.com`

#### Service Account Credentials

You can pass the service account credentials into this module by setting the following environment variables:

* `GOOGLE_APPLICATION_CREDENTIALS`

See more [details](https://www.terraform.io/docs/providers/google/provider_reference.html#configuration-reference).

## Provision Instructions

This module has no root configuration. A module with no root configuration cannot be used directly.

Copy and paste into your Terraform configuration, insert the variables, and run terraform init :

For PostgreSQL :

```
module "cloudsql-pgsql" {
   source = "git::git@github.com:jjmartres/terraform.git//gcp/cloudsql/postgresql?ref=master"
}
```