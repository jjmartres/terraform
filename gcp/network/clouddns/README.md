<!-- BEGIN_TF_DOCS -->

# Google Cloud DNS

This module makes it easy to create Google Cloud DNS zones of different types, and manage their records. It supports creating public, private, forwarding, and peering zones.

The resources/services/activations/deletions that this module will create/trigger are:

 - One `google_dns_managed_zone` for the zone
 - Zero or more `google_dns_record_set` for the zone recordsThis module is used to create an manage Google Kubernetes Cluster
## Repository

[https://github.com/terraform/-/tree/master/gcp/network/clouddns](https://github.com/terraform/-/tree/master/gcp/network/clouddns)

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
gcloud services enable dns.googleapis.com
```

Now create a service account for Terraform to use, generate a key file for it, and save the key location as an environment variable:

```bash
gcloud iam service-accounts create terraform --display-name "Terraform, Infrastructure as Code"
gcloud projects add-iam-policy-binding [project] --member serviceAccount:terraform@[project].iam.gserviceaccount.com --role roles/dns.admin
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
| <a name="input_default_key_specs_key"></a> [default\_key\_specs\_key](#input\_default\_key\_specs\_key) | Object containing default key signing specifications : `algorithm`, `key_length`, `key_type`, `kind`. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone.html#dnssec_config for futhers details | `any` | `{}` | no |
| <a name="input_default_key_specs_zone"></a> [default\_key\_specs\_zone](#input\_default\_key\_specs\_zone) | Object containing default zone signing specifications : `algorithm`, `key_length`, `key_type`, `kind`. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone.html#dnssec_config for futhers details | `any` | `{}` | no |
| <a name="input_description"></a> [description](#input\_description) | zone description (shown in console) | `string` | `"Managed by Terraform"` | no |
| <a name="input_dnssec_config"></a> [dnssec\_config](#input\_dnssec\_config) | Object containing : kind, non\_existence, state. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone.html#dnssec_config for futhers details | `any` | `{}` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Zone domain, must end with a period. | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | A set of key/value label pairs to assign to this ManagedZone | `map(any)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | The location (region or zone) in which the instance will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the instance will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Zone name, must be unique within the project. | `string` | n/a | yes |
| <a name="input_private_visibility_config_networks"></a> [private\_visibility\_config\_networks](#input\_private\_visibility\_config\_networks) | List of `VPC` self links that can see this zone. | `list(string)` | `[]` | no |
| <a name="input_project"></a> [project](#input\_project) | The project ID to manage the Cloud SQL resources | `string` | n/a | yes |
| <a name="input_recordsets"></a> [recordsets](#input\_recordsets) | List of DNS record objects to manage, in the standard terraform dns structure. Example:<pre>recordsets = [<br>    {<br>      name    = ""<br>      type    = "NS"<br>      ttl     = 300<br>      records = [<br>        "127.0.0.1",<br>      ]<br>    }<br>  ]</pre> | <pre>list(object({<br>    name    = string<br>    type    = string<br>    ttl     = number<br>    records = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_target_name_server_addresses"></a> [target\_name\_server\_addresses](#input\_target\_name\_server\_addresses) | List of target name servers for forwarding zone. | `list(string)` | `[]` | no |
| <a name="input_target_network"></a> [target\_network](#input\_target\_network) | Peering network. | `string` | `""` | no |
| <a name="input_type"></a> [type](#input\_type) | Type of zone to create, valid values are `public`, `private`, `forwarding`, `peering`. | `string` | `"private"` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domain"></a> [domain](#output\_domain) | The DNS zone domain. |
| <a name="output_name"></a> [name](#output\_name) | The DNS zone name. |
| <a name="output_name_servers"></a> [name\_servers](#output\_name\_servers) | The DNS zone name servers. |
| <a name="output_type"></a> [type](#output\_type) | The DNS zone type. |
## Usage
Basic usage of this submodule is as follows:

```hcl
module "routes" {
    source = "git::git@github.com:jjmartres/terraform.git//gcp/clouddns?ref=master"

  project    = "my-project"
  type       = "private"
  name       = "example-com"
  domain     = "example.com."

  private_visibility_config_networks = [
    "https://www.googleapis.com/compute/v1/projects/my-project/global/networks/my-vpc"
  ]

  recordsets = [
    {
      name    = ""
      type    = "NS"
      ttl     = 300
      records = [
        "127.0.0.1",
      ]
    },
    {
      name    = "localhost"
      type    = "A"
      ttl     = 300
      records = [
        "127.0.0.1",
      ]
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