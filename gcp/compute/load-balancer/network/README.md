<!-- BEGIN_TF_DOCS -->

# Google Cloud Network Load Balancer Module

This Terraform Module creates a [Network Load Balancer](https://cloud.google.com/load-balancing/docs/network/) using [forwarding rules](https://cloud.google.com/load-balancing/docs/network/#forwarding_rules) and [target pools](https://cloud.google.com/load-balancing/docs/network/#target_pools).

Google Cloud Platform (GCP) Internal TCP/UDP Load Balancing distributes traffic among VM instances in the same region in a VPC network using a private, internal (RFC 1918) IP address.

## Core concepts

- [What is Cloud Load Balancing](https://github.com/terraform/-/blob/master/gcp/compute/load-balancer/_docs/core-concepts.md#what-is-cloud-load-balancing)
- [HTTP(S) Load Balancer Terminology](https://github.com/terraform/-/blob/master/gcp/compute/load-balancer/_docs/core-concepts.md#https-load-balancer-terminology)
- [Cloud Load Balancing Documentation](https://cloud.google.com/load-balancing/)
## Repository

[https://github.com/terraform/-/tree/master/gcp/compute/load-balancer/network](https://github.com/terraform/-/tree/master/gcp/compute/load-balancer/network)

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
| <a name="input_custom_labels"></a> [custom\_labels](#input\_custom\_labels) | (Optional) A map of custom labels to apply to the resources. The key is the label name and the value is the label value. | `map(string)` | `{}` | no |
| <a name="input_enable_health_check"></a> [enable\_health\_check](#input\_enable\_health\_check) | (Optional) Flag to indicate if health check is enabled. If set to true, a firewall rule allowing health check probes is also created. | `bool` | `false` | no |
| <a name="input_firewall_target_tags"></a> [firewall\_target\_tags](#input\_firewall\_target\_tags) | (Optional) List of target tags for the health check firewall rule. | `list(string)` | `[]` | no |
| <a name="input_health_check_healthy_threshold"></a> [health\_check\_healthy\_threshold](#input\_health\_check\_healthy\_threshold) | (Optional) A so-far unhealthy instance will be marked healthy after this many consecutive successes. The default value is `2`. | `number` | `2` | no |
| <a name="input_health_check_interval"></a> [health\_check\_interval](#input\_health\_check\_interval) | (Optional) How often (in seconds) to send a health check. Default is `5`. | `number` | `5` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | (Optional) The request path of the HTTP health check request. The default value is `/`. | `string` | `"/"` | no |
| <a name="input_health_check_port"></a> [health\_check\_port](#input\_health\_check\_port) | (Optional) The TCP port number for the HTTP health check request. | `number` | `80` | no |
| <a name="input_health_check_timeout"></a> [health\_check\_timeout](#input\_health\_check\_timeout) | How long (in seconds) to wait before claiming failure. The default value is `5` seconds. It is invalid for `health_check_timeout` to have greater value than `health_check_interval` | `number` | `5` | no |
| <a name="input_health_check_unhealthy_threshold"></a> [health\_check\_unhealthy\_threshold](#input\_health\_check\_unhealthy\_threshold) | (Optional) A so-far healthy instance will be marked unhealthy after this many consecutive failures. The default value is `2`. | `number` | `2` | no |
| <a name="input_instances"></a> [instances](#input\_instances) | (Optional) List of self links to instances in the pool. Note that the instances need not exist at the time of target pool creation. | `list(string)` | `[]` | no |
| <a name="input_ip_address"></a> [ip\_address](#input\_ip\_address) | (Optional) IP address of the load balancer. If empty, an IP address will be automatically assigned. | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location (region or zone) in which the cluster master will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name for the load balancer forwarding rule and prefix for supporting resources. | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | (Optional) Self link of the VPC network in which to deploy the resources. | `string` | `"default"` | no |
| <a name="input_network_project"></a> [network\_project](#input\_network\_project) | (Optional) The name of the GCP Project where the network is located. Useful when using networks shared between projects. If empty, `var.project` will be used. | `string` | `null` | no |
| <a name="input_port_range"></a> [port\_range](#input\_port\_range) | (Optional) Only packets addressed to ports in the specified range will be forwarded to target. If empty, all packets will be forwarded. | `string` | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | (Required) The default project to manage resources in. | `string` | n/a | yes |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | (Optional) The protocol for the backend and frontend forwarding rule. TCP or UDP. | `string` | `"TCP"` | no |
| <a name="input_session_affinity"></a> [session\_affinity](#input\_session\_affinity) | (Optional) The session affinity for the backends, e.g.: `NONE,` `CLIENT_IP`. Default is `NONE`. | `string` | `"NONE"` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_forwarding_rule"></a> [forwarding\_rule](#output\_forwarding\_rule) | Self link of the forwarding rule (Load Balancer) |
| <a name="output_load_balancer_ip_address"></a> [load\_balancer\_ip\_address](#output\_load\_balancer\_ip\_address) | IP address of the Load Balancer |
| <a name="output_target_pool"></a> [target\_pool](#output\_target\_pool) | Self link of the target pool |
## Usage
Basic usage of this submodule is as follows:

```hcl
module "gcp_compute_llb_network" {
  source = "git::git@github.com:jjmartres/terraform.git//gcp/compute/load-balancer/network?ref=master"

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