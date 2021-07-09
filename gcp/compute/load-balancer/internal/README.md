<!-- BEGIN_TF_DOCS -->

# Google Cloud Internal Load Balancer Module

This Terraform Module creates an [Internal TCP/UDP Load Balancer](https://cloud.google.com/load-balancing/docs/internal/) using [internal forwarding rules](https://cloud.google.com/load-balancing/docs/internal/#forwarding_rule).

Google Cloud Platform (GCP) Internal TCP/UDP Load Balancing distributes traffic among VM instances in the same region in a VPC network using a private, internal (RFC 1918) IP address.

## Core concepts

- [What is Cloud Load Balancing](https://github.com/terraform/-/blob/master/gcp/compute/load-balancer/_docs/core-concepts.md#what-is-cloud-load-balancing)
- [HTTP(S) Load Balancer Terminology](https://github.com/terraform/-/blob/master/gcp/compute/load-balancer/_docs/core-concepts.md#https-load-balancer-terminology)
- [Cloud Load Balancing Documentation](https://cloud.google.com/load-balancing/)
## Repository

[https://github.com/terraform/-/tree/master/gcp/compute/load-balancer/internal](https://github.com/terraform/-/tree/master/gcp/compute/load-balancer/internal)

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
| <a name="input_backends"></a> [backends](#input\_backends) | (Required) List of backends, should be a map of key-value pairs for each backend, must have the 'group' key."<br><br>  Example:<pre>backends = [<br>    {<br>      description = "Sample Instance Group for Internal LB",<br>      group       = "The fully-qualified URL of an Instance Group"<br>    }<br>  ]</pre> | `list(map(string))` | n/a | yes |
| <a name="input_custom_labels"></a> [custom\_labels](#input\_custom\_labels) | (Optional) A map of custom labels to apply to the resources. The key is the label name and the value is the label value. | `map(string)` | `{}` | no |
| <a name="input_health_check_port"></a> [health\_check\_port](#input\_health\_check\_port) | (Required) Port to perform health checks on. | `number` | n/a | yes |
| <a name="input_http_health_check"></a> [http\_health\_check](#input\_http\_health\_check) | (Optional) Set to true if health check is type http, otherwise health check is tcp. | `bool` | `false` | no |
| <a name="input_ip_address"></a> [ip\_address](#input\_ip\_address) | (Optional) IP address of the load balancer. If empty, an IP address will be automatically assigned. | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location (region or zone) in which the cluster master will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name for the load balancer forwarding rule and prefix for supporting resources. | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | (Optional) Self link of the VPC network in which to deploy the resources. | `string` | `"default"` | no |
| <a name="input_network_project"></a> [network\_project](#input\_network\_project) | (Optional) The name of the GCP Project where the network is located. Useful when using networks shared between projects. If empty, var.project will be used. | `string` | `""` | no |
| <a name="input_ports"></a> [ports](#input\_ports) | (Required) List of ports (or port ranges) to forward to backend services. Max is `5`. | `list(string)` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | (Required) The default project to manage resources in. | `string` | n/a | yes |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | (Optional) The protocol for the backend and frontend forwarding rule. TCP or UDP. | `string` | `"TCP"` | no |
| <a name="input_service_label"></a> [service\_label](#input\_service\_label) | (Optional) An optional prefix to the service name for this Forwarding Rule. If specified, will be the first label of the fully qualified service name. | `string` | `""` | no |
| <a name="input_session_affinity"></a> [session\_affinity](#input\_session\_affinity) | (Optional) The session affinity for the backends, e.g.: `NONE`, `CLIENT_IP`. Default is `NONE`. | `string` | `"NONE"` | no |
| <a name="input_source_tags"></a> [source\_tags](#input\_source\_tags) | (Optional) List of source tags for traffic between the internal load balancer. | `list(string)` | `[]` | no |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | (Optional) Self link of the VPC subnetwork in which to deploy the resources. | `string` | `""` | no |
| <a name="input_target_tags"></a> [target\_tags](#input\_target\_tags) | (Optional) List of target tags for traffic between the internal load balancer. | `list(string)` | `[]` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_service"></a> [backend\_service](#output\_backend\_service) | Self link of the regional backend service. |
| <a name="output_forwarding_rule"></a> [forwarding\_rule](#output\_forwarding\_rule) | Self link of the forwarding rule (Load Balancer) |
| <a name="output_health_check_firewall"></a> [health\_check\_firewall](#output\_health\_check\_firewall) | Self link of the health check firewall rule. |
| <a name="output_load_balancer_domain_name"></a> [load\_balancer\_domain\_name](#output\_load\_balancer\_domain\_name) | The internal fully qualified service name for this Load Balancer |
| <a name="output_load_balancer_firewall"></a> [load\_balancer\_firewall](#output\_load\_balancer\_firewall) | Self link of the load balancer firewall rule. |
| <a name="output_load_balancer_ip_address"></a> [load\_balancer\_ip\_address](#output\_load\_balancer\_ip\_address) | IP address of the Load Balancer |
## Usage
Basic usage of this submodule is as follows:

```hcl
module "gcp_compute_llb_internal" {
  source = "git::git@github.com:jjmartres/terraform.git//gcp/compute/load-balancer/internal?ref=master"

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