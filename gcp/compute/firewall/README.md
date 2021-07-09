<!-- BEGIN_TF_DOCS -->

# Google Cloud Firewall

This module is used to create an manage Google Cloud firewall rules
## Repository

[https://github.com/terraform/-/tree/master/gcp/compute/firewall](https://github.com/terraform/-/tree/master/gcp/compute/firewall)

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
| <a name="input_description"></a> [description](#input\_description) | A short description of the rule | `string` | `""` | no |
| <a name="input_direction"></a> [direction](#input\_direction) | Direction of traffic to which this firewall applies; default is INGRESS. Note: For INGRESS traffic, it is NOT supported to specify destinationRanges; For EGRESS traffic, it is NOT supported to specify sourceRanges OR sourceTags. | `string` | `"ingress"` | no |
| <a name="input_disabled"></a> [disabled](#input\_disabled) | Denotes whether the firewall rule is disabled, i.e not applied to the network it is associated with. When set to true, the firewall rule is not enforced and the network behaves as if it did not exist. If this is unspecified, the firewall rule will be enabled. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | The location (region or zone) in which the cluster master will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well. | `string` | n/a | yes |
| <a name="input_log_config"></a> [log\_config](#input\_log\_config) | This field denotes the logging options for a particular firewall rule. If defined, logging is enabled, and logs will be exported to Cloud Logging. Possible values are EXCLUDE\_ALL\_METADATA and INCLUDE\_ALL\_METADATA | `string` | `"EXCLUDE_ALL_METADATA"` | no |
| <a name="input_module_depends_on"></a> [module\_depends\_on](#input\_module\_depends\_on) | n/a | `list` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name of the firewall rule. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash. | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | The name or self\_link of the network to attach this firewall to | `string` | `"default"` | no |
| <a name="input_priority"></a> [priority](#input\_priority) | Priority for the rule. This is an integer between 0 and 65535, both inclusive. When not specified, the value assumed is 1000. Relative priorities determine precedence of conflicting rules. Lower value of priority implies higher precedence (eg, a rule with priority 0 has higher precedence than a rule with priority 1). DENY rules take precedence over ALLOW rules having equal priority. | `number` | `1000` | no |
| <a name="input_project"></a> [project](#input\_project) | The default project to manage resources in. | `string` | n/a | yes |
| <a name="input_project_description"></a> [project\_description](#input\_project\_description) | A brief description of the resource. It will be use as a description of each resources | `string` | n/a | yes |
| <a name="input_rules"></a> [rules](#input\_rules) | Create and manage rules. For each rules, following arguments are supported:<br>    - protocol: (Required) The IP protocol to which this rule applies. The protocol type is required when creating a firewall rule. This value can either be one of the following well known protocol strings (tcp, udp, icmp, esp, ah, sctp), or the IP protocol number.<br>    - port: (Optional) An optional list of ports to which this rule applies. This field is only applicable for UDP or TCP protocol. Each entry must be either an integer or a range. If not specified, this rule applies to connections through any port. Example inputs include: ["22"], ["80","443"], and ["12345-12349"]. | `list(object({ protocol = string, ports = list(string)}))` | <pre>[<br>  {<br>    "ports": [<br>      "22"<br>    ],<br>    "protocol": "TCP"<br>  }<br>]</pre> | no |
| <a name="input_source_ranges"></a> [source\_ranges](#input\_source\_ranges) | If specified, the firewall will apply only to traffic that has source IP address in these ranges. These ranges must be expressed in CIDR format. One or both of sourceRanges and sourceTags may be set. If both properties are set, the firewall will apply to traffic that has source IP address within sourceRanges OR the source IP that belongs to a tag listed in the sourceTags property. The connection does not need to match both properties for the firewall to apply. Only IPv4 is supported. | `list(string)` | `[]` | no |
| <a name="input_source_tags"></a> [source\_tags](#input\_source\_tags) | If specified, the firewall will apply only to traffic with source IP that belongs to a tag listed in source tags. Source tags cannot be used to control traffic to an instance's external IP address. Because tags are associated with an instance, not an IP address. One or both of sourceRanges and sourceTags may be set. If both properties are set, the firewall will apply to traffic that has source IP address within sourceRanges OR the source IP that belongs to a tag listed in the sourceTags property. The connection does not need to match both properties for the firewall to apply. | `list(string)` | `[]` | no |
| <a name="input_target_tags"></a> [target\_tags](#input\_target\_tags) | A list of instance tags indicating sets of instances located in the network that may make network connections as specified in allowed[]. If no targetTags are specified, the firewall rule applies to all instances on the specified network. | `list(string)` | `[]` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rule"></a> [rule](#output\_rule) | Result is a map with the id, name, creation\_timestamp and self-link of the firewall rule |
| <a name="output_workspace"></a> [workspace](#output\_workspace) | n/a |
## Usage
Basic usage of this submodule is as follows:

```hcl
module "gcp_compute_firewall" {
  source = "git::git@github.com:jjmartres/terraform.git//gcp/compute/firewall?ref=master"

  project               = "arctic-math-252409"
  location              = "europe-west1-c"
  project_description   = "My super brief description"
  name                  = "firewall-rule-01"
  description           = "Simple firewall rule that allow ingress traffic"
  priority              = 20012
  source_tags           = ["terraform"]
  rules                 = [ {  protocol = "TCP", ports = ["22"] }, {  protocol = "TCP", ports = ["80","443"] }]
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