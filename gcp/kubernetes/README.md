<!-- BEGIN_TF_DOCS -->

# Google Cloud Kubernetes Engine a.k.a. GKE

This module is used to create an manage Google Kubernetes Cluster
## Repository

[https://github.com/terraform/-/tree/master/gcp/kubernetes](https://github.com/terraform/-/tree/master/gcp/kubernetes)

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
gcloud projects add-iam-policy-binding [PROJECT_ID] --member serviceAccount:terraform@[PROJECT_ID].iam.gserviceaccount.com --role roles/container.admin
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
| <a name="input_auto_repair"></a> [auto\_repair](#input\_auto\_repair) | (Optional) Whether the nodes will be automatically repaired | `bool` | `true` | no |
| <a name="input_auto_upgrade"></a> [auto\_upgrade](#input\_auto\_upgrade) | (Optional) Whether the nodes will be automatically upgraded | `bool` | `true` | no |
| <a name="input_create_timeout"></a> [create\_timeout](#input\_create\_timeout) | Timeout used for adding node pools | `number` | `30` | no |
| <a name="input_delete_timeout"></a> [delete\_timeout](#input\_delete\_timeout) | Timeout used for removing node pools | `number` | `30` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) Description of the cluster | `string` | n/a | yes |
| <a name="input_disk_size_gb"></a> [disk\_size\_gb](#input\_disk\_size\_gb) | (Optional) Size of the disk attached to each node, specified in GB. The smallest allowed disk size is `10GB` | `number` | `100` | no |
| <a name="input_disk_type"></a> [disk\_type](#input\_disk\_type) | (Optional) Type of the disk attached to each node (e.g. `pd-standard` or `pd-ssd`) | `string` | `"pd-standard"` | no |
| <a name="input_initial_node_count"></a> [initial\_node\_count](#input\_initial\_node\_count) | (Optional) The initial number of nodes for the pool. In regional or multi-zonal clusters, this is the number of nodes per zone. Changing this will force recreation of the resource | `number` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version to use. If not defined, the default node version will be used | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | The Kubernetes labels (key/value pairs) to be applied to each node. | `map(any)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | The location (region or zone) in which the cluster master will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well | `string` | n/a | yes |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | (Optional) The name of a Google Compute Engine machine type | `string` | `"n1-standard-1"` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | (Required) Time window specified for daily maintenance operations. Specify `start_time` in RFC3339 format HH:MM, where HH : [00-23] and MM : [00-59] GMT | `string` | `"03:30"` | no |
| <a name="input_max_node_count"></a> [max\_node\_count](#input\_max\_node\_count) | (Required) Maximum number of nodes in the NodePool. Must be `>= min_node_count` | `number` | `3` | no |
| <a name="input_min_node_count"></a> [min\_node\_count](#input\_min\_node\_count) | (Required) Minimum number of nodes in the NodePool. Must be `>=0` and `<=` | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the cluster, unique within the project and location | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | (Optional) The `name` or `self_link` of the Google Compute Engine network to which the cluster is connected. For Shared VPC, set this to the self link of the shared network | `string` | `"default"` | no |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | (Required) The number of nodes pools to create in the cluster | `number` | `3` | no |
| <a name="input_project"></a> [project](#input\_project) | The default project to manage resources in | `string` | n/a | yes |
| <a name="input_service_account"></a> [service\_account](#input\_service\_account) | The service account to run nodes. | `string` | `""` | no |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | (Optional) The `name` or `self_link` of the Google Compute Engine subnetwork in which the cluster's instances are launched | `string` | `"default"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) The list of instance tags applied to all nodes. Tags are used to identify valid sources or targets for network firewalls | `list(string)` | `[]` | no |
| <a name="input_update_timeout"></a> [update\_timeout](#input\_update\_timeout) | Timeout used for updates to node pools | `number` | `30` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster"></a> [cluster](#output\_cluster) | Result is a map with cluster information |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | The IP address of the cluster |
## Usage
Basic usage of this submodule is as follows:

```hcl
module "gcp_gke" {
  source = "git::git@github.com:jjmartres/terraform.git//gcp/kubernetes?ref=master"

  project               = "test-purpose-to-delete"
  location              = "europe-west1-c"
  bucket                = "arctic-math-252409-ias"
  bucket_prefix         = "instance/state"
  name                  = "my-super-cluster"
  description           = "my-super-description"
  node_pools            = 3
  initial_node_count    = 3
  min_node_count        = 1
  max_node_count        = 3
  machine_type          = "n1-standard-1"
  disk_type             = "pd-standard"
  disk_size_gb          = 100
  network               = "default"
  tags                  =  [ "infrastructure", "terraform", "test"]
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