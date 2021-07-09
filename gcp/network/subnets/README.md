<!-- BEGIN_TF_DOCS -->
# Google Cloud Subnets within VPC network

This submodule is part of the `gcp-network` module. It creates the individual `VPC` subnets.

It supports creating:

- Subnets within vpc network
## Repository

[https://github.com/terraform/-/tree/master/gcp/network/subnets](https://github.com/terraform/-/tree/master/gcp/network/subnets)

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
| <a name="input_location"></a> [location](#input\_location) | The location (region or zone) in which the instance will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the instance will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well | `string` | n/a | yes |
| <a name="input_module_depends_on"></a> [module\_depends\_on](#input\_module\_depends\_on) | List of modules or resources this module depends on. | `list(any)` | `[]` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name of the network being created | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The project ID to manage the Cloud SQL resources | `string` | n/a | yes |
| <a name="input_secondary_ranges"></a> [secondary\_ranges](#input\_secondary\_ranges) | Secondary ranges that will be used in some of the subnets | `map(list(object({ range_name = string, ip_cidr_range = string })))` | `{}` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | The list of subnets being created | `list(map(string))` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnets"></a> [subnets](#output\_subnets) | The created subnet resources |
## Usage
Basic usage of this submodule is as follows:

```hcl
module "gcp_subnets" {
    source = "git::git@github.com:jjmartres/terraform.git//gcp/network/subnets?ref=master"
    project   = "<PROJECT ID>"
    network_name = "example-vpc"

    subnets = [
        {
            subnet_name           = "subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = "europe-west1"
        },
        {
            subnet_name           = "subnet-02"
            subnet_ip             = "10.10.20.0/24"
            subnet_region         = "europe-west1"
            subnet_private_access = "true"
            subnet_flow_logs      = "true"
            description           = "This subnet has a description"
        },
        {
            subnet_name               = "subnet-03"
            subnet_ip                 = "10.10.30.0/24"
            subnet_region             = "europe-west1"
            subnet_flow_logs          = "true"
            subnet_flow_logs_interval = "INTERVAL_10_MIN"
            subnet_flow_logs_sampling = 0.7
            subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
        }
    ]

    secondary_ranges = {
        subnet-01 = [
            {
                range_name    = "subnet-01-secondary-01"
                ip_cidr_range = "192.168.64.0/24"
            },
        ]

        subnet-02 = []
    }
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