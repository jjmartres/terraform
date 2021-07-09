<!-- BEGIN_TF_DOCS -->

# Google Cloud billing budget

This module allows the creation of a google billing budget tied to a specific project\_id
## Repository

[https://github.com/terraform/-/tree/master/gcp/billing/budget](https://github.com/terraform/-/tree/master/gcp/billing/budget)

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
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | n/a |
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
gcloud services enable pubsub.googleapis.com
gcloud services enable iam.googleapis.com
```

Now create a service account for Terraform to use, generate a key file for it, and save the key location as an environment variable:

```bash
gcloud iam service-accounts create terraform --display-name "Terraform, Infrastructure as Code"
gcloud projects add-iam-policy-binding [PROJECT_ID] --member serviceAccount:terraform@[PROJECT_ID].iam.gserviceaccount.com --role roles/pubsub.admin
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
| <a name="input_alert_pubsub_topic"></a> [alert\_pubsub\_topic](#input\_alert\_pubsub\_topic) | The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}` | `string` | `null` | no |
| <a name="input_alert_spent_percents"></a> [alert\_spent\_percents](#input\_alert\_spent\_percents) | A list of percentages of the budget to alert on when threshold is exceeded | `list(number)` | <pre>[<br>  0.5,<br>  0.7,<br>  1<br>]</pre> | no |
| <a name="input_amount"></a> [amount](#input\_amount) | The amount to use as the budget | `number` | n/a | yes |
| <a name="input_billing_account"></a> [billing\_account](#input\_billing\_account) | ID of the billing account to set a budget on | `string` | n/a | yes |
| <a name="input_create_budget"></a> [create\_budget](#input\_create\_budget) | If the budget should be created | `bool` | `true` | no |
| <a name="input_credit_types_treatment"></a> [credit\_types\_treatment](#input\_credit\_types\_treatment) | Specifies how credits should be treated when determining spend for threshold calculations | `string` | `"INCLUDE_ALL_CREDITS"` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | The display name of the budget. If not set defaults to `Budget For <projects[0]|All Projects>` | `string` | `null` | no |
| <a name="input_monitoring_notification_channels"></a> [monitoring\_notification\_channels](#input\_monitoring\_notification\_channels) | A list of monitoring notification channels in the form `[projects/{project_id}/notificationChannels/{channel_id}]`. A maximum of 5 channels are allowed. | `list(string)` | `[]` | no |
| <a name="input_projects"></a> [projects](#input\_projects) | The project ids to include in this budget. If empty budget will include all projects | `list(string)` | n/a | yes |
| <a name="input_services"></a> [services](#input\_services) | A list of services ids to be included in the budget. If omitted, all services will be included in the budget. Service ids can be found at https://cloud.google.com/skus/ | `list(string)` | `null` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | Resource name of the budget. Values are of the form `billingAccounts/{billingAccountId}/budgets/{budgetId}.` |
## Usage
Basic usage of this submodule is as follows:

```hcl
module "budget" {
  source = "git::git@github.com:jjmartres/terraform.git//gcp/resources/budget?ref=master"

  billing_account = "ABCD-1234-ABCD-1234"
  projects        = ["my-project-id"]
  amount          = "100"
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