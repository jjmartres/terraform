<!-- BEGIN_TF_DOCS -->

# Google Cloud Compute snapshot

This module is used to create snapshot policy and attach disks to this policy.
## Repository

[https://github.com/terraform/-/tree/master/gcp/compute/snapshot](https://github.com/terraform/-/tree/master/gcp/compute/snapshot)

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
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 3.10.0 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 3.10.0 |
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

Ensure the required APIs are enabled:

```bash
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable iam.googleapis.com
```

Now create a service account for Terraform to use, generate a key file for it, and save the key location as an environment variable:

```bash
gcloud iam service-accounts create terraform --display-name "Terraform, Infrastructure as Code"
gcloud projects add-iam-policy-binding [PROJECT_ID] --member serviceAccount:terraform@[PROJECT_ID].iam.gserviceaccount.com --role roles/compute.admin
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
| <a name="input_daily_schedule"></a> [daily\_schedule](#input\_daily\_schedule) | (Optional) The policy will execute every nth day at the specified time:<br>    - `days_in_cycle`: (Required) The number of days between snapshots.<br>    - `start_time`: (Required) This must be in UTC format that resolves to one of 00:00, 04:00, 08:00, 12:00, 16:00, or 20:00. For example, both 13:00-5 and 08:00 are valid.<pre>daily_schedule = [{<br>      days_in_cycle = 2<br>      start_time     = "04:00"<br>  }]</pre> | `list(object({  days_in_cycle = number, start_time = string}))` | `[]` | no |
| <a name="input_disks_to_attach"></a> [disks\_to\_attach](#input\_disks\_to\_attach) | (Required) The list of disks in which the resource policies are attached to. | `list(string)` | `[]` | no |
| <a name="input_guest_flush"></a> [guest\_flush](#input\_guest\_flush) | (Optional) Whether to perform a `guest aware` snapshot. | `bool` | `false` | no |
| <a name="input_hourly_schedule"></a> [hourly\_schedule](#input\_hourly\_schedule) | (Optional) The policy will execute every nth hour starting at the specified time:<br>    - `hours_in_cycle`: (Required) The number of hours between snapshots.<br>    - `start_time`: (Required) Time within the window to start the operations. It must be in an hourly format "HH:MM", where HH : [00-23] and MM : [00] GMT. eg: 21:00.<pre>hourly_schedule = [{<br>      hours_in_cycle = 20<br>      start_time     = "23:00"<br>  }]</pre> | `list(object({  hours_in_cycle = number, start_time = string}))` | `[]` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | (Optional) A set of key-value pairs<pre>labels ={<br>    key1 = "value1",<br>    key2 = "value2"<br>  }</pre> | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | The location (region or zone) in which the cluster master will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well. | `string` | n/a | yes |
| <a name="input_max_retention_days"></a> [max\_retention\_days](#input\_max\_retention\_days) | (Required) Maximum age of the snapshot that is allowed to be kept. | `number` | `7` | no |
| <a name="input_module_depends_on"></a> [module\_depends\_on](#input\_module\_depends\_on) | n/a | `list` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_on_source_disk_delete"></a> [on\_source\_disk\_delete](#input\_on\_source\_disk\_delete) | (Optional) Specifies the behavior to apply to scheduled snapshots when the source disk is deleted. Valid options are `KEEP_AUTO_SNAPSHOTS` and `APPLY_RETENTION_POLICY` | `string` | `"KEEP_AUTO_SNAPSHOTS"` | no |
| <a name="input_policy_name_prefix"></a> [policy\_name\_prefix](#input\_policy\_name\_prefix) | The prefix used to name policy. For example: prod-sql | `string` | `"policy"` | no |
| <a name="input_project"></a> [project](#input\_project) | The default project to manage resources in. | `string` | n/a | yes |
| <a name="input_weekly_schedule"></a> [weekly\_schedule](#input\_weekly\_schedule) | (Optional) Allows specifying a snapshot time for each day of the week:<br>    - `day`: (Required) The day of the week to create the snapshot. e.g. MONDAY<br>    - `start_time`: (Required) Time within the window to start the operations. It must be in format "HH:MM", where HH : [00-23] and MM : [00-00] GMT.<pre>weekly_schedule = [{<br>    day = "monday",<br>    start_time = "04:00"<br>  }]</pre> | `list(object({  day = string, start_time = string}))` | `[]` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_attached_disks"></a> [attached\_disks](#output\_attached\_disks) | List of disk attached to the schedule policy |
| <a name="output_snapshot_schedule_policy"></a> [snapshot\_schedule\_policy](#output\_snapshot\_schedule\_policy) | The created schedule policy |
## Usage
Basic usage of this submodule is as follows:

```hcl
module "gcp_compute_snqpshot" {
  source = "git::git@github.com:jjmartres/terraform.git//gcp/compute/snapshot?ref=master"

  project            = "test-purpose-to-delete"
  location           = "europe-west1-c"
  policy_name_prefix = "plop"
  weekly_schedule = [{
    day = "monday",
    start_time = "04:00"
  }]
  max_retention_days = 7
  on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
  labels = { 
    key1 = "value1", 
    key2 = "value2" 
  }
  guest_flush = false
  disks_to_attach = [ 
    "plop-001", 
    "plop-002"
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