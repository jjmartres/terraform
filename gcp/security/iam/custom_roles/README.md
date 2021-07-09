<!-- BEGIN_TF_DOCS -->
# Google Cloud IAM Custom Role

This module is used to create custom roles at organization or project level. The module supports creating custom rules optionally using predefined roles as a base, with additional permissions or excluded permissions.

Permissions that are [unsupported](https://cloud.google.com/iam/docs/custom-roles-permissions-support) from custom roles are automatically excluded.
## Repository

[https://github.com/terraform/-/tree/master/gcp/security/iam/custom_roles](https://github.com/terraform/-/tree/master/gcp/security/iam/custom_roles)

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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.13 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
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
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable compute.googleapis.com
```

Now create a service account for Terraform to use, generate a key file for it, and save the key location as an environment variable:

```bash
gcloud iam service-accounts create terraform --display-name "Terraform, Infrastructure as Code"
gcloud projects add-iam-policy-binding [project] --member serviceAccount:terraform@[project].iam.gserviceaccount.com --role roles/compute.networkAdmin
gcloud iam service-accounts keys create terraform.json --iam-account terraform@[project].iam.gserviceaccount.com
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
| <a name="input_base_roles"></a> [base\_roles](#input\_base\_roles) | List of base predefined roles to use to compose custom role. | `list(string)` | `[]` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of Custom role. | `string` | `""` | no |
| <a name="input_excluded_permissions"></a> [excluded\_permissions](#input\_excluded\_permissions) | List of permissions to exclude from custom role. | `list(string)` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | The location (region or zone) in which the instance will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the instance will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well | `string` | n/a | yes |
| <a name="input_members"></a> [members](#input\_members) | List of members to be added to custom role. | `list(string)` | n/a | yes |
| <a name="input_permissions"></a> [permissions](#input\_permissions) | IAM permissions assigned to Custom Role. | `list(string)` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The project ID to manage the Cloud SQL resources | `string` | n/a | yes |
| <a name="input_role_id"></a> [role\_id](#input\_role\_id) | ID of the Custom Role. | `string` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | The current launch stage of the role. Defaults to GA. | `string` | `"GA"` | no |
| <a name="input_target_id"></a> [target\_id](#input\_target\_id) | Variable for project or organization ID. | `string` | n/a | yes |
| <a name="input_target_level"></a> [target\_level](#input\_target\_level) | String variable to denote if custom role being created is at project or organization level. | `string` | `"project"` | no |
| <a name="input_title"></a> [title](#input\_title) | Human-readable title of the Custom Role, defaults to `role_id`. | `string` | `""` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_custom_role_id"></a> [custom\_role\_id](#output\_custom\_role\_id) | ID of the custom role created. |
## Usage
Basic usage of this submodule is as follows:
#### Custom Role at Organization Level
```hcl
module "custom-roles" {
    source = "git::git@github.com:jjmartres/terraform.git//gcp/iam/custom_roles?ref=master"
    
    target_level         = "org"
    target_id            = "123456789"
    role_id              = "custom_role_id"
    title                = "Custom Role Unique Title"
    description          = "Custom Role Description"
    base_roles           = ["roles/iam.serviceAccountAdmin"]
    permissions          = ["iam.roles.list", "iam.roles.create", "iam.roles.delete"]
    excluded_permissions = ["iam.serviceAccounts.setIamPolicy"]
    members              = ["user:user01@domain.com", "group:group01@domain.com"]
}
```
#### Custom Role at Project Level
```hcl
module "custom-roles" {
    source = "git::git@github.com:jjmartres/terraform.git//gcp/iam/custom_roles?ref=master"
    
    target_level         = "project"
    target_id            = "project_id_123"
    role_id              = "custom_role_id"
    title                = "Custom Role Unique Title"
    description          = "Custom Role Description"
    base_roles           = ["roles/iam.serviceAccountAdmin"]
    permissions          = ["iam.roles.list", "iam.roles.create", "iam.roles.delete"]
    excluded_permissions = ["iam.serviceAccounts.setIamPolicy"]
    members              = ["serviceAccount:member01@${var.target_id}.iam.gserviceaccount.com", "serviceAccount:member02@${var.target_id}.iam.gserviceaccount.com"]
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