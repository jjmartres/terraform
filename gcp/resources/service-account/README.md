<!-- BEGIN_TF_DOCS -->
# Google Cloud Service Accounts Terraform module

This module allows easy creation of one or more service accounts, and granting them basic roles.

The resources/services/activations/deletions that this module will create/trigger are:

- one or more service accounts
- optional project-level IAM role bindings for each service account
- one optional billing IAM role binding per service account, at the organization or billing account level
- two optional organization-level IAM bindings per service account, to enable the service accounts to create and manage Shared VPC networks
- one optional service account key per service account
## Repository

[https://github.com/terraform/-/tree/master/gcp/resources/service-account](https://github.com/terraform/-/tree/master/gcp/resources/service-account)

### Clone with SSH
Use a password-protected SSH key.
```bash
git clone git@github.com:jjmartres/terraform.git
```

###  Clone with HTTP
Use Git or checkout with SVN using the web URL.
```bash
git clone https://github.com/jjmartres/terraform.git
```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |
## IAM

Service account or user credentials with the following roles must be used to provision the resources of this module:

- Service Account Admin: `roles/iam.serviceAccountAdmin`
- (optional) Service Account Key Admin: `roles/iam.serviceAccountAdmin` when `generate_keys` is set to `true`
- (optional) roles needed to grant optional IAM roles at the project or organizational level

## Setup
The following guide assumes commands are run from the `local` directory.

Provide the input variables with a `variables.auto.tfvars` file which can be created from the example file provided:

```bash
cp variables.auto.tfvars.example variables.auto.tfvars
```

The values set in this file should be edited according to your environment and requirements.

Once the Cloud SDK is installed you can authenticating, set the project, and choose a compute zone with the interactive command:

```bash
gcloud init
```

Ensure the required APIs are enabled:

```bash
gcloud services enable storage-api.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable iam.googleapis.com
```

Now create a service account for Terraform to use, generate a key file for it, and save the key location as an environment variable:

```bash
gcloud iam service-accounts create terraform --display-name "Terraform, Infrastructure as Code"
gcloud projects add-iam-policy-binding [PROJECT_ID] --member serviceAccount:terraform@[PROJECT_ID].iam.gserviceaccount.com --role roles/compute.admin
gcloud projects add-iam-policy-binding [PROJECT_ID] --member serviceAccount:terraform@[PROJECT_ID].iam.gserviceaccount.com --role roles/storage.admin
gcloud projects add-iam-policy-binding [PROJECT_ID] --member serviceAccount:terraform@[PROJECT_ID].iam.gserviceaccount.com --role roles/iam.serviceAccountUser
gcloud iam service-accounts keys create terraform.json --iam-account terraform@[PROJECT_ID].iam.gserviceaccount.com
```

**NOTE: Keep the key file in a safe place, and do not share or publicise it.**

Next export environment variable that wil be used by Terraform!

```bash
export GOOGLE_APPLICATION_CREDENTIALS="$PWD/${USER}-terraform-admin.json"
export GCP_TERRAFORM_BUCKET=tfstate-gcp-bucket
```

Next, initialise Terraform with the name of the GCS Bucket just created:

 * bucket : the name of the GCS bucket. This name must be globally unique;
 * bucket_prefix: GCS prefix inside the bucket. Named states for workspaces are stored in an object called `<prefix>/<name>.tfstate`

```bash
terraform init -backend-config=bucket=${GCP_TERRAFORM_BUCKET} -backend-config=prefix=[BUCKET_PREFIX]
```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_account_id"></a> [billing\_account\_id](#input\_billing\_account\_id) | If assigning billing role, specificy a billing account (default is to assign at the organizational level). | `string` | `""` | no |
| <a name="input_generate_keys"></a> [generate\_keys](#input\_generate\_keys) | Generate keys for service accounts. | `bool` | `false` | no |
| <a name="input_grant_billing_role"></a> [grant\_billing\_role](#input\_grant\_billing\_role) | Grant billing administrator role. | `bool` | `false` | no |
| <a name="input_grant_org_role"></a> [grant\_org\_role](#input\_grant\_org\_role) | Grant organization administrator role. | `bool` | `false` | no |
| <a name="input_grant_xpn_roles"></a> [grant\_xpn\_roles](#input\_grant\_xpn\_roles) | Grant roles for shared VPC management. | `bool` | `false` | no |
| <a name="input_names"></a> [names](#input\_names) | Names of the service accounts to create. They must be 6-30 characters long, and match the regular expression `[a-z]([-a-z0-9]*[a-z0-9])` to comply with RFC1035. | `list(string)` | n/a | yes |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | Id of the organization for org-level roles. | `string` | `""` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix applied to service account names. | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project id where service account will be created. | `string` | n/a | yes |
| <a name="input_project_roles"></a> [project\_roles](#input\_project\_roles) | Common roles to apply to all service accounts, `project=>role` as elements. | `list(string)` | `[]` | no |
| <a name="input_suffix"></a> [suffix](#input\_suffix) | Suffix applied to service account names. | `string` | `""` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_email"></a> [email](#output\_email) | Service account email (for single use). |
| <a name="output_emails"></a> [emails](#output\_emails) | Service account emails by name. |
| <a name="output_emails_list"></a> [emails\_list](#output\_emails\_list) | Service account emails as list. |
| <a name="output_iam_email"></a> [iam\_email](#output\_iam\_email) | IAM-format service account email (for single use). |
| <a name="output_iam_emails"></a> [iam\_emails](#output\_iam\_emails) | IAM-format service account emails by name. |
| <a name="output_iam_emails_list"></a> [iam\_emails\_list](#output\_iam\_emails\_list) | IAM-format service account emails as list. |
| <a name="output_key"></a> [key](#output\_key) | Service account key (for single use). |
| <a name="output_keys"></a> [keys](#output\_keys) | Map of service account keys. |
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | Service account resource (for single use). |
| <a name="output_service_accounts"></a> [service\_accounts](#output\_service\_accounts) | Service account resources as list. |
| <a name="output_service_accounts_map"></a> [service\_accounts\_map](#output\_service\_accounts\_map) | Service account resources by name. |
## Usage
Basic usage of this submodule is as follows:

```hcl
module "gcp_sa" {
    source = "git::git@github.com:jjmartres/terraform.git//gcp/resources/service-account?ref=master"
    project_id = "test-purpose-to-delete"
    names = ["plopfirst"]
    project_roles = [
      "test-purpose-to-delete=>roles/compute.admin",
      "test-purpose-to-delete=>roles/viewer"
    ]
    grant_projectcreator_role = true
    grant_billing_role = true
}
```
### Applying

Now that Terraform is setup check that the configuration is valid:

```bash
terraform validate 
```

To get a complete list of the different resources Terraform will create to achieve the state described in the configuration files you just wrote, run :

```bash
terraform plan
```

If the configuration is valid then apply it with:

```bash
terraform apply [-auto-approve]
```

Inspect the output of apply to ensure that what Terraform is going to do what you want, if so then enter `yes` at the prompt.
The infrastructure will then be created, this make take a some time.


### Clean Up

Remove the infrastructure created by Terraform with:

```bash
terraform destroy [-auto-approve]
rm -rf .terraform
```

Sometimes Terraform may report a failure to destroy some resources due to dependencies and timing contention.
In this case wait a few seconds and run the above command again. If it is still unable to remove everything it may be necessary to remove resources manually using the `gcloud` command or the Cloud Console.

The GCS Bucket used for Terraform state storage can be removed with:

```bash
gsutil rm -r gs://[BUCKET]
```
<!-- other.md -->
<!-- END_TF_DOCS -->