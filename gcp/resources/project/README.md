<!-- BEGIN_TF_DOCS -->
# Google Cloud project

This module is used to create an manage project for a specific Google Cloud Organization ID
## Repository

[https://github.com/terraform/-/tree/master/gcp/resources/project](https://github.com/terraform/-/tree/master/gcp/resources/project)

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
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
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
gcloud services enable iam.googleapis.com
```

Now create a service account for Terraform to use, generate a key file for it, and save the key location as an environment variable:

```bash
gcloud iam service-accounts create terraform --display-name "Terraform, Infrastructure as Code"
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
| <a name="input_api_services"></a> [api\_services](#input\_api\_services) | (Optional) List of Google APIs to activate on this project | `list(string)` | `[]` | no |
| <a name="input_auto_create_network"></a> [auto\_create\_network](#input\_auto\_create\_network) | (Optional) Create the 'default' network automatically. Default true. If set to false, the default network will be deleted. Note that, for quota purposes, you will still need to have 1 network slot available to create the project successfully, even if you set auto\_create\_network to false, since the network will exist momentarily. | `bool` | `true` | no |
| <a name="input_billing_account"></a> [billing\_account](#input\_billing\_account) | (Optional) The alphanumeric ID of the billing account this project belongs to. The user or service account performing this operation with Terraform must have Billing Account Administrator privileges (roles/billing.admin) in the organization. See Google Cloud Billing API Access Control for more details. | `string` | n/a | yes |
| <a name="input_default_region"></a> [default\_region](#input\_default\_region) | (Optional) The region used by default to create new resources | `string` | `""` | no |
| <a name="input_default_zone"></a> [default\_zone](#input\_default\_zone) | (Optional) The zone within a region used by default to create new resources | `string` | `""` | no |
| <a name="input_enable_oslogin"></a> [enable\_oslogin](#input\_enable\_oslogin) | Use Cloud OS Login API to manage OS login configuration for Google account users | `bool` | `false` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | (Optional) The numeric ID of the folder this project should be created under. Only one of org\_id or folder\_id may be specified. If the folder\_id is specified, then the project is created under the specified folder. Changing this forces the project to be migrated to the newly specified folder. | `string` | `""` | no |
| <a name="input_iam_bindings"></a> [iam\_bindings](#input\_iam\_bindings) | (Optional) Updates the IAM policy to grant a role to a list of members. Authoritative for a given role. Other roles within the IAM policy for the project are preserved. | `map(list(string))` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The display name of the project | `string` | n/a | yes |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | (Optional) The numeric ID of the organization this project belongs to. Changing this forces a new project to be created. Only one of org\_id or folder\_id may be specified. If the org\_id is specified then the project is created at the top level. Changing this forces the project to be migrated to the newly specified organization. | `string` | n/a | yes |
| <a name="input_skip_delete"></a> [skip\_delete](#input\_skip\_delete) | (Optional) If true, the Terraform resource can be deleted without deleting the Project via the Google API. | `bool` | `false` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_project"></a> [project](#output\_project) | Result is a map with the id, the name and the folder of the created project |
## Usage
Basic usage of this submodule is as follows:

```hcl
module "gcp_project" {
    source = "git::git@github.com:jjmartres/terraform.git//gcp/resources/project?ref=master"
    projectid = "my-project-id"
    api_services = [
      "cloudbilling.googleapis.com",
      "cloudresourcemanager.googleapis.com",
      "compute.googleapis.com",
      "serviceusage.googleapis.com",
    ]
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