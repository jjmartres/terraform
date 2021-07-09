<!-- BEGIN_TF_DOCS -->

# Google Cloud HTTP(S) Load Balancer Module

This Terraform Module creates an [HTTP(S) Cloud Load Balancer](https://cloud.google.com/load-balancing/docs/https/) using [global forwarding rules](https://cloud.google.com/load-balancing/docs/https/global-forwarding-rules).

HTTP(S) load balancing can balance HTTP and HTTPS traffic across multiple backend instances, across multiple regions. Your entire app is available via a single global IP address, resulting in a simplified DNS setup. HTTP(S) load balancing is scalable, fault-tolerant, requires no pre-warming, and enables content-based load balancing.

## Core concepts

- [What is Cloud Load Balancing](https://github.com/terraform/-/blob/master/gcp/compute/load-balancer/_docs/core-concepts.md#what-is-cloud-load-balancing)
- [HTTP(S) Load Balancer Terminology](https://github.com/terraform/-/blob/master/gcp/compute/load-balancer/_docs/core-concepts.md#https-load-balancer-terminology)
- [Cloud Load Balancing Documentation](https://cloud.google.com/load-balancing/)
## Repository

[https://github.com/terraform/-/tree/master/gcp/compute/load-balancer/http](https://github.com/terraform/-/tree/master/gcp/compute/load-balancer/http)

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
| <a name="input_create_dns_entries"></a> [create\_dns\_entries](#input\_create\_dns\_entries) | If set to true, create a DNS A Record in Cloud DNS for each domain specified in 'custom\_domain\_names'. | `bool` | `false` | no |
| <a name="input_custom_domain_names"></a> [custom\_domain\_names](#input\_custom\_domain\_names) | List of custom domain names. | `list(string)` | `[]` | no |
| <a name="input_custom_labels"></a> [custom\_labels](#input\_custom\_labels) | A map of custom labels to apply to the resources. The key is the label name and the value is the label value. | `map(string)` | `{}` | no |
| <a name="input_dns_managed_zone_name"></a> [dns\_managed\_zone\_name](#input\_dns\_managed\_zone\_name) | The name of the Cloud DNS Managed Zone in which to create the DNS A Records specified in 'var.custom\_domain\_names'. Only used if 'var.create\_dns\_entries' is true. | `string` | `"replace-me"` | no |
| <a name="input_dns_record_ttl"></a> [dns\_record\_ttl](#input\_dns\_record\_ttl) | The time-to-live for the site A records (seconds) | `number` | `300` | no |
| <a name="input_enable_http"></a> [enable\_http](#input\_enable\_http) | Set to true to enable plain http. Note that disabling http does not force SSL and/or redirect HTTP traffic. See https://issuetracker.google.com/issues/35904733 | `bool` | `true` | no |
| <a name="input_enable_ssl"></a> [enable\_ssl](#input\_enable\_ssl) | Set to true to enable ssl. If set to 'true', you will also have to provide 'var.ssl\_certificates'. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | The location (region or zone) in which the cluster master will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name for the load balancer forwarding rule and prefix for supporting resources. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The default project to manage resources in. | `string` | n/a | yes |
| <a name="input_ssl_certificates"></a> [ssl\_certificates](#input\_ssl\_certificates) | List of SSL cert self links. Required if 'enable\_ssl' is 'true'. | `list(string)` | `[]` | no |
| <a name="input_url_map"></a> [url\_map](#input\_url\_map) | A reference (self\_link) to the url\_map resource to use. | `string` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_load_balancer_ip_address"></a> [load\_balancer\_ip\_address](#output\_load\_balancer\_ip\_address) | IP address of the Cloud Load Balancer |
## Usage
Basic usage of this submodule is as follows:

```hcl
module "gcp_compute_llb_http" {
  source = "git::git@github.com:jjmartres/terraform.git//gcp/compute/load-balancer/http?ref=master"

  project = "test-purpose-to-delete"
  location = "europe-west1-c"
  name = "my-super-load-balancer"
  url_map = ""

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