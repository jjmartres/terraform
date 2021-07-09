<!-- BEGIN_TF_DOCS -->

# Datadog synthetics SSL test

This module is used to create and manage Datadog synthetics SSL test
## Repository

[https://github.com/terraform/-/tree/master/datadog/synthetics/api-ssl](https://github.com/terraform/-/tree/master/datadog/synthetics/api-ssl)

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
| <a name="provider_datadog"></a> [datadog](#provider\_datadog) | n/a |
## Setup
The following guide assumes commands are run from the `local` directory.

Provide the input variables with a `variables.auto.tfvars` file which can be created from the example file provided:

```bash
cp variables.auto.tfvars.example variables.auto.tfvars
```

The values set in this file should be edited according to your environment and requirements.

Next export environment variable that will be used by Terraform!

```bash
export GOOGLE_APPLICATION_CREDENTIALS="$PWD/${USER}-terraform-admin.json"
export GCP_TERRAFORM_BUCKET=tfstate-gcp-bucket
export DATADOG_API_KEY=<DATADOG_API_KEY>
export DATADOG_APP_KEY=<DATADOG_APP_KEY>
export DATADOG_HOST="https://api.datadoghq.eu/"
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
| <a name="input_accept_self_signed"></a> [accept\_self\_signed](#input\_accept\_self\_signed) | Accept or not SSL self signed certificates | `bool` | `false` | no |
| <a name="input_host"></a> [host](#input\_host) | (Required) Hostname to request SSL validity | `string` | n/a | yes |
| <a name="input_locations"></a> [locations](#input\_locations) | (Required) List of Datadog locations where test are executed. Please refer to Datadog documentation for available locations: https://docs.datadoghq.com/fr/api/?lang=bash#get-available-locations | `list(string)` | n/a | yes |
| <a name="input_message"></a> [message](#input\_message) | (Required) A message to include with notifications for this synthetics test. Email notifications can be sent to specific users by using the same `@username` notation as events. | `string` | n/a | yes |
| <a name="input_min_failure_duration"></a> [min\_failure\_duration](#input\_min\_failure\_duration) | How long the test should be in failure before alerting (integer, number of seconds, max 7200) | `number` | `0` | no |
| <a name="input_min_location_failed"></a> [min\_location\_failed](#input\_min\_location\_failed) | Threshold below which a synthetics test is allowed to fail before sending notifications | `number` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name of Datadog synthetics test | `string` | n/a | yes |
| <a name="input_operator"></a> [operator](#input\_operator) | Operator used to check SSL validity. Can be `isInMoreThan` or `isInLessThan` | `string` | `"isInLessThan"` | no |
| <a name="input_period"></a> [period](#input\_period) | Number of days until SSL certificate expire | `number` | `30` | no |
| <a name="input_port"></a> [port](#input\_port) | (Required) Port of the hostname to request SSL validity | `number` | `443` | no |
| <a name="input_status"></a> [status](#input\_status) | (Required) Status of the synthetics test. Can be `live` or `paused` | `string` | `"live"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Required) A list of tags to associate with your synthetics test. This can help you categorize and filter tests in the manage synthetics page of the UI | `list(string)` | n/a | yes |
| <a name="input_tick_every"></a> [tick\_every](#input\_tick\_every) | (Required) How often the test should run (in seconds). Current possible values are 900, 1800, 3600, 21600, 43200, 86400, 604800 | `number` | `1800` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_attributes"></a> [attributes](#output\_attributes) | Information about the synthetics test resource |
| <a name="output_locations"></a> [locations](#output\_locations) | Locations where synthetics are run |
## Usage
Basic usage of this submodule is as follows:

```hcl
module "dd_syn_api_ssl
  source = "git::git@github.com:jjmartres/terraform.git//datadog/synthetics/api-ssl?ref=master"

  name = "Test of ssl validity"
  status = "live"
  tags = [
    "env:test",
    "foo"
  ]
  host = "zorglub.com"
  port = 443
  operator = "isInLessThan"
  period = 15
  message = "@slack-Zorglub-monitoring"
  tick_every = 1800
  accept_self_signed = false
  locations = [
    "aws:ap-northeast-1",
    "aws:ap-northeast-2",
    "aws:ap-south-1",
    "aws:ap-southeast-1",
    "aws:ap-southeast-2",
    "aws:ca-central-1",
    "aws:eu-central-1",
    "aws:eu-west-1",
    "aws:eu-west-2",
    "aws:sa-east-1",
    "aws:us-east-2",
    "aws:us-west-1",
    "aws:us-west-2"
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