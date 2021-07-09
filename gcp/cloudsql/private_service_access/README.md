<!-- BEGIN_TF_DOCS -->

# Submodule for VPC peering Cloud SQL services

[Private IP](https://cloud.google.com/sql/docs/mysql/private-ip) configurations require a special peering between your VPC network and a VPC managed by Google. The module supports creating such a peering.
It is sufficient to instantiate this module once for all MySQL/PostgreSQL instances that are connected to the same VPC.
## Repository

[https://github.com/terraform/-/tree/master/gcp/cloudsql/private_service_access](https://github.com/terraform/-/tree/master/gcp/cloudsql/private_service_access)

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
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | n/a |
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
gcloud services enable sqladmin.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable servicenetworking.googleapis.com
```

Now create a service account for Terraform to use, generate a key file for it, and save the key location as an environment variable:

```bash
gcloud iam service-accounts create terraform --display-name "Terraform, Infrastructure as Code"
gcloud projects add-iam-policy-binding [project] --member serviceAccount:terraform@[project].iam.gserviceaccount.com --role roles/cloudsql.admin
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
| <a name="input_address"></a> [address](#input\_address) | First IP address of the IP range to allocate to CLoud SQL instances and other Private Service Access services. If not set, GCP will pick a valid one for you. | `string` | `""` | no |
| <a name="input_ip_version"></a> [ip\_version](#input\_ip\_version) | IP Version for the allocation. Can be IPV4 or IPV6. | `string` | `""` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | The key/value labels for the IP range allocated to the peered network. | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | The location (region or zone) in which the instance will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the instance will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well | `string` | n/a | yes |
| <a name="input_module_depends_on"></a> [module\_depends\_on](#input\_module\_depends\_on) | List of modules or resources this module depends on. | `list(any)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the resource. Provided by the client when the resource is created. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash. | `string` | `""` | no |
| <a name="input_network"></a> [network](#input\_network) | Name of VPC network connected with service producers using VPC peering. | `string` | n/a | yes |
| <a name="input_prefix_length"></a> [prefix\_length](#input\_prefix\_length) | Prefix length of the IP range reserved for Cloud SQL instances and other Private Service Access services. Defaults to /16. | `number` | `16` | no |
| <a name="input_project"></a> [project](#input\_project) | The project ID to manage the Cloud SQL resources | `string` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_address"></a> [address](#output\_address) | First IP of the reserved range. |
| <a name="output_google_compute_global_address_name"></a> [google\_compute\_global\_address\_name](#output\_google\_compute\_global\_address\_name) | URL of the reserved range. |
| <a name="output_peering_completed"></a> [peering\_completed](#output\_peering\_completed) | Use for enforce ordering between resource creation |
## Usage
Basic usage of this submodule is as follows:

```hcl
module "gcp_cloudsql_private_service_access" {
  source = "git::git@github.com:jjmartres/terraform.git//gcp/cloudsql/private_service_access?ref=master"

  project = "arctic-math-252409"
  location = "europe-west1-c"
  vpc_network = "default"
  name = "example-network"
  address = ""
  prefix_length = "20"
  ip_version = "ipv4"
  labels = {
    "plop": "test",
    "env": "dev",
    "svc": "cloudsql"
  }
}
```
### Applying

Now that Terraform is setup check that the configuration is valid:

```
terraform validate 
```

To get a complete list of the different resources Terraform will create to achieve the state described in the configuration files you just wrote, run :

```
terraform plan
```

If the configuration is valid then apply it with:

```
terraform apply [-auto-approve]
```

Inspect the output of apply to ensure that what Terraform is going to do what you want, if so then enter `yes` at the prompt.
The infrastructure will then be created, this make take a some time.


### Clean Up

Remove the infrastructure created by Terraform with:

```
terraform destroy [-auto-approve]
rm -rf .terraform
```

Sometimes Terraform may report a failure to destroy some resources due to dependencies and timing contention.
In this case wait a few seconds and run the above command again. If it is still unable to remove everything it may be necessary to remove resources manually using the `gcloud` command or the Cloud Console.

The GCS Bucket used for Terraform state storage can be removed with:

```
gsutil rm -r gs://[BUCKET]
```
<!-- other.md -->
<!-- END_TF_DOCS -->