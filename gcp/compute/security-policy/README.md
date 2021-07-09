<!-- BEGIN_TF_DOCS -->

# Google Cloud Compute Security Policy (Cloud Armor)

This module is used to create and manage security policy rules
## Repository

[https://github.com/terraform/-/tree/master/gcp/compute/security-policy](https://github.com/terraform/-/tree/master/gcp/compute/security-policy)

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
| <a name="input_default_action"></a> [default\_action](#input\_default\_action) | (Required) The default action to take. Valid values:<br>        - `allow`: allow access to target<br>        - `deny(status)` : deny access to target, returns the HTTP response code specified (valid values are `403`, `404` and `502`) | `string` | `"deny(502)"` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) An optional description of this security policy. Max size is `2048`. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location (region or zone) in which the cluster master will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the security policy | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The default project to manage resources in. | `string` | n/a | yes |
| <a name="input_rules"></a> [rules](#input\_rules) | The set of rules that belong to this policy. For each rules, following arguments are supported:<br>    - `action`: (required) The action to take when rule match. Possible values are:<br>          - `allow`: allow access to target<br>          - `deny(status)` : deny access to target, returns the HTTP response code specified (valid values are 403, 404 and 502)<br>    - `priority`:  (Required) An unique positive integer indicating the priority of evaluation for a rule. Rules are evaluated from highest priority (lowest numerically) to lowest priority (highest numerically) in order.<br>    - `description`: (optional) An optional description of this rule. Max size is 64.<br>    - `src_ip_ranges`: (required) Set of IP addresses or ranges (IPV4 or IPV6) in CIDR notation to match against inbound traffic. There is a limit of 5 IP ranges per rule. A value of '*' matches all IPs (can be used to override the default behavior).<br><br>  Example:<pre>rule = [<br>      {<br>        action = "allow",<br>        priority = 1000,<br>        description = "My first rules",<br>        src_ip_ranges = [<br>          "1.1.1.1/32",<br>          "2.2.2.2/32"]<br>      }<br>    ]</pre> | `list(object({ action = string, priority = number, description = string, src_ip_ranges = list(string)}))` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fingerprint"></a> [fingerprint](#output\_fingerprint) | Fingerprint of this resource. |
| <a name="output_id"></a> [id](#output\_id) | Id of the security policy |
| <a name="output_self_link"></a> [self\_link](#output\_self\_link) | The URI of the created resource |
## Usage
Basic usage of this submodule is as follows:

```hcl
module "gcp_compute_security_policy" {
  source = "git::git@github.com:jjmartres/terraform.git//gcp/compute/security-policy?ref=master"

  project = "test-purpose-to-delete"
  location = "europe-west1-c"
  name = "my-first-security-rules"
  description = "My super policy rules"
  default_action = "deny(502)"
  rules = [
    {
      action = "allow",
      priority = 1000,
      description = "My first rules",
      src_ip_ranges = [
        "1.1.1.1/32",
        "2.2.2.2/32"]
    },
   {
      action = "allow",
      priority = 1001,
      description = "My second rules",
      src_ip_ranges = [
        "4.4.4.4/32"]
   },
 ]
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