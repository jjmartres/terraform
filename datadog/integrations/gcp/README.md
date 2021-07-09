<!-- BEGIN_TF_DOCS -->

# Datadog Google Cloud Platform integration resource

This module is used to create and manage Google Cloud Platform integration into Datadog.
## Repository

[https://github.com/terraform/-/tree/master/datadog/integrations/gcp](https://github.com/terraform/-/tree/master/datadog/integrations/gcp)

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
| <a name="input_client_email"></a> [client\_email](#input\_client\_email) | (Required) Your email found in your JSON service account key | `string` | n/a | yes |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | (Required) Your ID found in your JSON service account key | `string` | n/a | yes |
| <a name="input_host_filters"></a> [host\_filters](#input\_host\_filters) | (Optional) Limit the GCE instances that are pulled into Datadog by using tags. Only hosts that match one of the defined tags are imported into Datadog. | `string` | n/a | yes |
| <a name="input_private_key"></a> [private\_key](#input\_private\_key) | (Required) Your private key name found in your JSON service account key | `string` | n/a | yes |
| <a name="input_private_key_id"></a> [private\_key\_id](#input\_private\_key\_id) | (Required) Your private key ID found in your JSON service account key | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | (Required) Your Google Cloud project ID found in your JSON service account key | `string` | n/a | yes |
## Outputs

No outputs.
## Usage
Basic usage of this submodule is as follows:

```hcl
module "dd_gcp_integrations" {
 source = "git::git@github.com:jjmartres/terraform.git//datadog/integrations/gcp?ref=master"

 project_id     = "awesome-project-id"
 private_key_id = "1234567890123456789012345678901234567890"
 private_key    = "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"
 client_email   = "awesome-service-account@awesome-project-id.iam.gserviceaccount.com"
 client_id      = "123456789012345678901"
 host_filters   = "foo:bar,buzz:lightyear"
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