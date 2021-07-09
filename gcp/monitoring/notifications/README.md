<!-- BEGIN_TF_DOCS -->

# Google Cloud notification channels

This module allows the creation of notification channels to a specific `project_id`
## Repository

[https://github.com/terraform/-/tree/master/gcp/monitoring/notifications](https://github.com/terraform/-/tree/master/gcp/monitoring/notifications)

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
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
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

Now create a service account for Terraform to use, generate a key file for it, and save the key location as an environment variable:

```bash
gcloud iam service-accounts create terraform --display-name "Terraform, Infrastructure as Code"
gcloud projects add-iam-policy-binding [project] --member serviceAccount:terraform@[project].iam.gserviceaccount.com --role roles/monitoring.notificationChannelEditor
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
| <a name="input_module_depends_on"></a> [module\_depends\_on](#input\_module\_depends\_on) | List of modules or resources this module depends on. | `list(any)` | `[]` | no |
| <a name="input_notification_group_email"></a> [notification\_group\_email](#input\_notification\_group\_email) | Email of the group to notify | `string` | `""` | no |
| <a name="input_notification_name"></a> [notification\_name](#input\_notification\_name) | An optional human-readable name for this notification channel. It is recommended that you specify a non-empty and unique name in order to make it easier to identify the channels in your project, though this is not enforced. The display name is limited to 512 Unicode characters. | `string` | n/a | yes |
| <a name="input_notification_slack_channel"></a> [notification\_slack\_channel](#input\_notification\_slack\_channel) | The slack channel to notify | `string` | `""` | no |
| <a name="input_project"></a> [project](#input\_project) | The default project to manage resources in | `string` | n/a | yes |
| <a name="input_project_id_slack_token"></a> [project\_id\_slack\_token](#input\_project\_id\_slack\_token) | `project_id` where an authorization token for a notification channel is stored | `string` | `""` | no |
| <a name="input_secret_id"></a> [secret\_id](#input\_secret\_id) | This must be the unique `secret_id` within the project. | `string` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_notification_channels"></a> [notification\_channels](#output\_notification\_channels) | The list of notification channels |
## Usage
Basic usage of this submodule is as follows:

```hcl
module "gcp_notification" {
  source = "git::git@github.com:jjmartres/terraform.git//gcp/monitoring/notifications?ref=master"

  project        = "my-project-id"
  notification_name = "My notification"
  notification_group_email = "notification_email@domain.com"
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