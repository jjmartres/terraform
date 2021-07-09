<!-- BEGIN_TF_DOCS -->
# Google Cloud VPC network

This submodule is part of the the `gcp-network` module. It creates a vpc network and optionally enables it as a Shared VPC host project.

It supports creating:

- A VPC Network
- Optionally enabling the network as a Shared VPC host
## Repository

[https://github.com/terraform/-/tree/master/gcp/network/vpc](https://github.com/terraform/-/tree/master/gcp/network/vpc)

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
 gcloud services enable compute.googleapis.com
 ```
 
 Now create a service account for Terraform to use, generate a key file for it, and save the key location as an environment variable:
 
 ```bash
 gcloud iam service-accounts create terraform --display-name "Terraform, Infrastructure as Code"
 gcloud projects add-iam-policy-binding [project] --member serviceAccount:terraform@[project].iam.gserviceaccount.com --role roles/compute.xpnAdmin
 gcloud organizations add-iam-policy-binding [project] --member serviceAccount:terraform@[project].iam.gserviceaccount.com --role roles/compute.networkAdmin
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
| <a name="input_auto_create_subnetworks"></a> [auto\_create\_subnetworks](#input\_auto\_create\_subnetworks) | When set to true, the network is created in auto subnet mode and it will create a subnet for each region automatically across the `10.128.0.0/9` address range. When set to false, the network is created in custom subnet mode so the user can explicitly connect subnetwork resources. | `bool` | `false` | no |
| <a name="input_delete_default_internet_gateway_routes"></a> [delete\_default\_internet\_gateway\_routes](#input\_delete\_default\_internet\_gateway\_routes) | If set, ensure that all routes within the network specified whose names begin with `default-route` and with a next hop of `default-internet-gateway` are deleted | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | An optional description of this resource. The resource must be recreated to modify this field. | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | The location (region or zone) in which the instance will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the instance will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well | `string` | n/a | yes |
| <a name="input_module_depends_on"></a> [module\_depends\_on](#input\_module\_depends\_on) | List of modules or resources this module depends on. | `list(any)` | `[]` | no |
| <a name="input_mtu"></a> [mtu](#input\_mtu) | The network MTU. Must be a value between `1460` and `1500` inclusive. If set to 0 (meaning MTU is unset), the network will default to `1460` automatically. | `number` | `1460` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name of the network being created | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The project ID to manage the Cloud SQL resources | `string` | n/a | yes |
| <a name="input_routing_mode"></a> [routing\_mode](#input\_routing\_mode) | The network routing mode (default `GLOBAL`). Possible values are `REGIONAL` or `GLOBAL` | `string` | `"GLOBAL"` | no |
| <a name="input_shared_vpc_host"></a> [shared\_vpc\_host](#input\_shared\_vpc\_host) | Makes this project a Shared VPC host if true (default false) | `bool` | `false` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network"></a> [network](#output\_network) | The VPC resource being created |
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | The name of the VPC being created |
| <a name="output_network_self_link"></a> [network\_self\_link](#output\_network\_self\_link) | The URI of the VPC being created |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | VPC project id |
## Usage
Basic usage of this submodule is as follows:

```hcl
module "gcp_vpc" {
    source = "git::git@github.com:jjmartres/terraform.git//gcp/network/vpc?ref=master"
    project   = "<PROJECT ID>"
    location = "europe-west1-c"

    network_name = "tf-demo-module"
    description = "Demo of the network VPC Terraform module"
    shared_vpc_host = true
    mtu = 1460
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