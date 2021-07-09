<!-- BEGIN_TF_DOCS -->

# Google Cloud Compute instance

This module is used to create an manage Google Cloud Compute instance
## Repository

[https://github.com/terraform/-/tree/master/gcp/compute/instance](https://github.com/terraform/-/tree/master/gcp/compute/instance)

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
| <a name="input_auto_delete"></a> [auto\_delete](#input\_auto\_delete) | Whether the disk will be auto-deleted when the instance is deleted. | `bool` | `true` | no |
| <a name="input_disk_size_gb"></a> [disk\_size\_gb](#input\_disk\_size\_gb) | Size of the instance disk. | `number` | `80` | no |
| <a name="input_disk_type"></a> [disk\_type](#input\_disk\_type) | The GCE disk type. One of pd-standard or pd-ssd. | `string` | `"pd-standard"` | no |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | Operating system images to create boot disks for the instance | `string` | `"ubuntu-1804-lts"` | no |
| <a name="input_instances_count"></a> [instances\_count](#input\_instances\_count) | Number of instances to create. | `number` | `1` | no |
| <a name="input_instances_name_prefix"></a> [instances\_name\_prefix](#input\_instances\_name\_prefix) | The prefix used to name instance(s). For example: prod-sql | `string` | `"node"` | no |
| <a name="input_instances_tags"></a> [instances\_tags](#input\_instances\_tags) | Tags associated with instances. | `list(string)` | <pre>[<br>  "infrastructure",<br>  "terraform"<br>]</pre> | no |
| <a name="input_location"></a> [location](#input\_location) | The location (region or zone) in which the cluster master will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well. | `string` | n/a | yes |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | Type of the node compute engines. | `string` | `"n1-standard-4"` | no |
| <a name="input_module_depends_on"></a> [module\_depends\_on](#input\_module\_depends\_on) | n/a | `list` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_network"></a> [network](#input\_network) | The VPC network to host the instances in | `string` | `"default"` | no |
| <a name="input_project"></a> [project](#input\_project) | The default project to manage resources in. | `string` | n/a | yes |
| <a name="input_project_description"></a> [project\_description](#input\_project\_description) | A brief description of the resource. It will be use as a description of each resources | `string` | n/a | yes |
| <a name="input_startup_script"></a> [startup\_script](#input\_startup\_script) | An alternative to using the startup-script metadata key, except this one forces the instance to be recreated (thus re-running the script) if it is changed. This replaces the startup-script metadata key on the created instance and thus the two mechanisms are not allowed to be used simultaneously. | `string` | `null` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instances"></a> [instances](#output\_instances) | Result is a an array of map of instances and their name, id, public\_ip, private\_ip and self-link |
| <a name="output_name_list"></a> [name\_list](#output\_name\_list) | Result is a list of instance name |
| <a name="output_workspace"></a> [workspace](#output\_workspace) | n/a |
## Usage
Basic usage of this submodule is as follows:

```hcl
module "gcp_compute_instance" {
  source = "git::git@github.com:jjmartres/terraform.git//gcp/compute/instance?ref=master"

  project               = "test-purpose-to-delete"
  location              = "europe-west1-c"
  project_description   = "My super brief description"
  instances_count       = 2
  instances_name_prefix = "plop"
  instances_tags        =  [ "infrastructure", "terraform", "test"]
  auto_delete           = true
  image_name            = "ubuntu-1804-lts"
  machine_type          = "n1-standard-4"
  disk_type             = "pd-standard"
  disk_size_gb          = 100
  network               = "default"

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