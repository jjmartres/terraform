<!-- BEGIN_TF_DOCS -->
# Google Cloud KMS

Simple Cloud KMS module that allows managing a keyring, zero or more keys in the keyring, and IAM role bindings on individual keys.

The resources/services/activations/deletions that this module will create/trigger are:

- Create a KMS keyring in the provided project
- Create zero or more keys in the keyring
- Create IAM role bindings for owners, encrypters, decrypters
## Repository

[https://github.com/terraform/-/tree/master/gcp/security/kms](https://github.com/terraform/-/tree/master/gcp/security/kms)

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
 gcloud services enable cloudkms.googleapis.com
 ```
 
 Now create a service account for Terraform to use, generate a key file for it, and save the key location as an environment variable:
 
 ```bash
 gcloud iam service-accounts create terraform --display-name "Terraform, Infrastructure as Code"
 gcloud projects add-iam-policy-binding [project] --member serviceAccount:terraform@[project].iam.gserviceaccount.com --role roles/cloudkms.admin
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
| <a name="input_decrypters"></a> [decrypters](#input\_decrypters) | List of comma-separated owners for each key declared in `set_decrypters_for`. | `list(string)` | `[]` | no |
| <a name="input_encrypters"></a> [encrypters](#input\_encrypters) | List of comma-separated owners for each key declared in `set_encrypters_for`. | `list(string)` | `[]` | no |
| <a name="input_key_algorithm"></a> [key\_algorithm](#input\_key\_algorithm) | The algorithm to use when creating a version based on this template. See the https://cloud.google.com/kms/docs/reference/rest/v1/CryptoKeyVersionAlgorithm for possible inputs. | `string` | `"GOOGLE_SYMMETRIC_ENCRYPTION"` | no |
| <a name="input_key_protection_level"></a> [key\_protection\_level](#input\_key\_protection\_level) | The protection level to use when creating a version based on this template. Default value: `SOFTWARE` Possible values: `SOFTWARE`, `HSM` | `string` | `"SOFTWARE"` | no |
| <a name="input_key_rotation_period"></a> [key\_rotation\_period](#input\_key\_rotation\_period) | Every time this period passes, generate a new `CryptoKeyVersion` and set it as the primary. The first rotation will take place after the specified period. The rotation period has the format of a decimal number with up to 9 fractional digits, followed by the letter `s` (seconds). It must be greater than a `day` (ie, `86400`). | `string` | `"100000s"` | no |
| <a name="input_keyring"></a> [keyring](#input\_keyring) | Keyring name. | `string` | n/a | yes |
| <a name="input_keys"></a> [keys](#input\_keys) | Key names. | `list(string)` | `[]` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels, provided as a map | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | The location (region or zone) in which the instance will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the instance will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well | `string` | n/a | yes |
| <a name="input_owners"></a> [owners](#input\_owners) | List of comma-separated owners for each key declared in `set_owners_for`. | `list(string)` | `[]` | no |
| <a name="input_prevent_destroy"></a> [prevent\_destroy](#input\_prevent\_destroy) | Set the prevent\_destroy lifecycle attribute on keys. | `bool` | `true` | no |
| <a name="input_project"></a> [project](#input\_project) | The project ID to manage the Cloud SQL resources | `string` | n/a | yes |
| <a name="input_set_decrypters_for"></a> [set\_decrypters\_for](#input\_set\_decrypters\_for) | Name of keys for which decrypters will be set. | `list(string)` | `[]` | no |
| <a name="input_set_encrypters_for"></a> [set\_encrypters\_for](#input\_set\_encrypters\_for) | Name of keys for which encrypters will be set. | `list(string)` | `[]` | no |
| <a name="input_set_owners_for"></a> [set\_owners\_for](#input\_set\_owners\_for) | Name of keys for which owners will be set. | `list(string)` | `[]` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_keyring"></a> [keyring](#output\_keyring) | Self link of the keyring. |
| <a name="output_keyring_name"></a> [keyring\_name](#output\_keyring\_name) | Name of the keyring. |
| <a name="output_keyring_resource"></a> [keyring\_resource](#output\_keyring\_resource) | Keyring resource. |
| <a name="output_keys"></a> [keys](#output\_keys) | Map of key name => key self link. |
## Usage
Basic usage of this submodule is as follows:
```hcl
module "gcp_kms" {
  source = "git::git@github.com:jjmartres/terraform.git//gcp/network/routes?ref=master"

  project        = "<PROJECT ID>"
  location           = "europe"
  keyring            = "sample-keyring"
  keys               = ["foo", "spam"]
  set_owners_for     = ["foo", "spam"]
  owners = [
    "group:one@example.com,group:two@example.com",
    "group:one@example.com",
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