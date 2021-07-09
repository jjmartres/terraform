<!-- BEGIN_TF_DOCS -->
# Google Cloud Network VPC

This submodule is part of the the `gcp-network` module.  It allows creation of a [VPC Network Peering](https://cloud.google.com/vpc/docs/vpc-peering) between two networks.

It supports creating:

- one network peering from `local network` to `peer network`
- one network peering from `peer network` to `local network`
## Repository

[https://github.com/terraform/-/tree/master/gcp/network/network-peering](https://github.com/terraform/-/tree/master/gcp/network/network-peering)

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
| <a name="input_export_local_custom_routes"></a> [export\_local\_custom\_routes](#input\_export\_local\_custom\_routes) | Export custom routes to peer network from local network. | `bool` | `false` | no |
| <a name="input_export_local_subnet_routes_with_public_ip"></a> [export\_local\_subnet\_routes\_with\_public\_ip](#input\_export\_local\_subnet\_routes\_with\_public\_ip) | Export custom routes to peer network from local network (defaults to `true`; causes the Local Peering Connection to align with the [provider default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_peering#export_subnet_routes_with_public_ip), and the Remote Peering Connection to be opposite the provider default). | `bool` | `true` | no |
| <a name="input_export_peer_custom_routes"></a> [export\_peer\_custom\_routes](#input\_export\_peer\_custom\_routes) | Export custom routes to local network from peer network. | `bool` | `false` | no |
| <a name="input_export_peer_subnet_routes_with_public_ip"></a> [export\_peer\_subnet\_routes\_with\_public\_ip](#input\_export\_peer\_subnet\_routes\_with\_public\_ip) | Export custom routes to local network from peer network (defaults to `false`; causes the Local Peering Connection to align with the [provider default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_peering#import_subnet_routes_with_public_ip), and the Remote Peering Connection to be opposite the provider default). | `bool` | `false` | no |
| <a name="input_local_network"></a> [local\_network](#input\_local\_network) | Resource link of the network to add a peering to. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location (region or zone) in which the instance will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the instance will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well | `string` | n/a | yes |
| <a name="input_module_depends_on"></a> [module\_depends\_on](#input\_module\_depends\_on) | List of modules or resources this module depends on. | `list(any)` | `[]` | no |
| <a name="input_peer_network"></a> [peer\_network](#input\_peer\_network) | Resource link of the peer network. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Name prefix for the network peerings | `string` | `"network-peering"` | no |
| <a name="input_project"></a> [project](#input\_project) | The project ID to manage the Cloud SQL resources | `string` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_complete"></a> [complete](#output\_complete) | Output to be used as a module dependency. |
| <a name="output_local_network_peering"></a> [local\_network\_peering](#output\_local\_network\_peering) | Network peering resource. |
| <a name="output_peer_network_peering"></a> [peer\_network\_peering](#output\_peer\_network\_peering) | Peer network peering resource. |
## Usage
Basic usage of this submodule is as follows:

```hcl
module "peering" {
  source = "git::git@github.com:jjmartres/terraform.git//gcp/network/network-peering?ref=master"

  prefix        = "name-prefix"
  local_network = "<FIRST NETWORK SELF LINK>"
  peer_network  = "<SECOND NETWORK SELF LINK>"
}
```
If you need to create more than one peering for the same VPC Network `(A -> B, A -> C)` you have to use output from the first module as a dependency for the second one to keep order of peering creation (It is not currently possible to create more than one peering connection for a VPC Network at the same time).

```hcl
module "peering-a-b" {
  source = "git::git@github.com:jjmartres/terraform.git//gcp/network/network-peering?ref=master"

  prefix        = "name-prefix"
  local_network = "<A NETWORK SELF LINK>"
  peer_network  = "<B NETWORK SELF LINK>"
}

module "peering-a-c" {
  source = "git::git@github.com:jjmartres/terraform.git//gcp/network/network-peering?ref=master"

  prefix        = "name-prefix"
  local_network = "<A NETWORK SELF LINK>"
  peer_network  = "<C NETWORK SELF LINK>"

  module_depends_on = [module.peering-a-b.complete]
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