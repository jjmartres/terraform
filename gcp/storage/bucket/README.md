<!-- BEGIN_TF_DOCS -->
# Google Cloud Storage Buckets

This module is used to create Google Cloud Storage buckets.
## Repository

[https://github.com/terraform/-/tree/master/gcp/storage/bucket](https://github.com/terraform/-/tree/master/gcp/storage/bucket)

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
gcloud services enable storage-api.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable iam.googleapis.com
```

Now create a service account for Terraform to use, generate a key file for it, and save the key location as an environment variable:

```bash
gcloud iam service-accounts create terraform --display-name "Terraform, Infrastructure as Code"
gcloud projects add-iam-policy-binding [project] --member serviceAccount:terraform@[project].iam.gserviceaccount.com --role roles/compute.admin
gcloud projects add-iam-policy-binding [project] --member serviceAccount:terraform@[project].iam.gserviceaccount.com --role roles/storage.admin
gcloud projects add-iam-policy-binding [project] --member serviceAccount:terraform@[project].iam.gserviceaccount.com --role roles/iam.serviceAccountUser
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
| <a name="input_cors_max_age_seconds"></a> [cors\_max\_age\_seconds](#input\_cors\_max\_age\_seconds) | The value, in seconds, to return in the Access-Control-Max-Age header used in preflight responses. | `number` | `0` | no |
| <a name="input_cors_methods"></a> [cors\_methods](#input\_cors\_methods) | The list of HTTP methods on which to include CORS response headers, (GET, OPTIONS, POST, etc) Note: `*` is permitted in the list of methods, and means 'any method'. | `list(string)` | `[]` | no |
| <a name="input_cors_origins"></a> [cors\_origins](#input\_cors\_origins) | The list of Origins eligible to receive CORS response headers. Note: `*` is permitted in the list of origins, and means 'any Origin'. See also: https://tools.ietf.org/html/rfc6454. | `list(string)` | `[]` | no |
| <a name="input_cors_response_headers"></a> [cors\_response\_headers](#input\_cors\_response\_headers) | The list of HTTP headers other than the simple response headers to give permission for the user-agent to share across domains. | `list(string)` | `[]` | no |
| <a name="input_default_acl"></a> [default\_acl](#input\_default\_acl) | The default ACL for the bucket, see: https://cloud.google.com/storage/docs/access-control/lists#predefined-acl. | `string` | `""` | no |
| <a name="input_enable_backend_bucket"></a> [enable\_backend\_bucket](#input\_enable\_backend\_bucket) | If true, a backend associated to the created bucket will be defined | `bool` | `false` | no |
| <a name="input_enable_cdn"></a> [enable\_cdn](#input\_enable\_cdn) | If true, enable Cloud CDN for backend bucket. | `bool` | `true` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | When deleting a bucket, this boolean option will delete all contained objects. If you try to delete a bucket that contains objects, Terraform will fail that run. | `bool` | `false` | no |
| <a name="input_kms_key_sl"></a> [kms\_key\_sl](#input\_kms\_key\_sl) | A `self_link` to a Cloud KMS key to be used to encrypt objects in this bucket, see also: https://cloud.google.com/storage/docs/encryption/using-customer-managed-keys. If this is not supplied then default encryption is used. | `string` | `""` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | A set of key/value label pairs to assign to the bucket. See also:https://cloud.google.com/resource-manager/docs/creating-managing-labels#requirements. | `map(any)` | `{}` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | The lifecycle rules to be applied to this bucket. If this array is populated then each element in it will be applied as a lifecycle rule to this bucket. The structure of each element is described in detail here: https://www.terraform.io/docs/providers/google/r/storage_bucket.html#lifecycle_rule. See also: https://cloud.google.com/storage/docs/lifecycle#configuration. | `list(any)` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | The GCS location. Please see: https://cloud.google.com/storage/docs/bucket-locations | `string` | `"US"` | no |
| <a name="input_log_bucket"></a> [log\_bucket](#input\_log\_bucket) | The name of the bucket to which access logs for this bucket should be written. If this is not supplied then no access logs are written. | `string` | `""` | no |
| <a name="input_log_object_prefix"></a> [log\_object\_prefix](#input\_log\_object\_prefix) | The prefix for access log objects. If this is not provided then GCS defaults it to the name of the source bucket. | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the bucket. If this is not supplied then a name will be generated for you using a combination of var.project and a random suffix. This approach to naming is in accordance with GCS bucket naming best practices, see: https://cloud.google.com/storage/docs/best-practices#naming. | `string` | `""` | no |
| <a name="input_predefined_acl"></a> [predefined\_acl](#input\_predefined\_acl) | One of the canned bucket ACLs, see https://cloud.google.com/storage/docs/access-control/lists#predefined-acl for more details. Must be set if `var.role_entity` is not. | `string` | `""` | no |
| <a name="input_project"></a> [project](#input\_project) | The default project id to manage resources in. | `string` | n/a | yes |
| <a name="input_retention_policy_is_locked"></a> [retention\_policy\_is\_locked](#input\_retention\_policy\_is\_locked) | If set to true, the bucket will be locked and any changes to the bucket's retention policy will be permanently restricted. Caution: Locking a bucket is an irreversible action. | `bool` | `false` | no |
| <a name="input_retention_policy_retention_period"></a> [retention\_policy\_retention\_period](#input\_retention\_policy\_retention\_period) | The period of time, in seconds, that objects in the bucket must be retained and cannot be deleted, overwritten, or archived. The value must be less than `3,155,760,000 seconds`. If this is supplied then a bucket retention policy will be created. | `string` | `""` | no |
| <a name="input_role_entity"></a> [role\_entity](#input\_role\_entity) | List of role/entity pairs in the form ROLE:entity. See https://cloud.google.com/storage/docs/json_api/v1/bucketAccessControls for more details. Must be set if `var.predefined_acl` is not. | `list(any)` | `[]` | no |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | The storage class of the bucket. upported values include: `STANDARD`, `MULTI_REGIONAL`, `REGIONAL`, `NEARLINE`, `COLDLINE`. See: https://cloud.google.com/storage/docs/storage-classes | `string` | `"STANDARD"` | no |
| <a name="input_uniform_bucket_level_access"></a> [uniform\_bucket\_level\_access](#input\_uniform\_bucket\_level\_access) | Enables Uniform bucket-level access access to a bucket. | `bool` | `false` | no |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | If true then versioning is enabled for all objects in this bucket. | `bool` | `false` | no |
| <a name="input_website_main_page_suffix"></a> [website\_main\_page\_suffix](#input\_website\_main\_page\_suffix) | The name of a file in the bucket which will act as the `index` page to be served by GCS if this bucket is hosting a static website. See also: https://cloud.google.com/storage/docs/hosting-static-website. | `string` | `""` | no |
| <a name="input_website_not_found_page"></a> [website\_not\_found\_page](#input\_website\_not\_found\_page) | The name of the `not found` page to be served by GCS if this bucket is hosting a static website. See also: https://cloud.google.com/storage/docs/hosting-static-website. | `string` | `""` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend"></a> [backend](#output\_backend) | The backend self\_link of the created bucket |
| <a name="output_name"></a> [name](#output\_name) | The name of the bucket created |
| <a name="output_self_link"></a> [self\_link](#output\_self\_link) | The self link of the bucket created |
| <a name="output_url"></a> [url](#output\_url) | The base URL of the bucket created, in the form `gs://<name>` |
## Usage
Basic usage of this submodule is as follows:
```hcl
module "gcp_storage_bucket" {
    source = "git::git@github.com:jjmartres/terraform.git//gcp/storage/bucket?ref=master"

    project = "test-purpose-to-delete"
    location = "europe-west1"
    storage_class = "REGIONAL"
    force_destroy = true
    uniform_bucket_level_access = true
    versioning_enabled = true
}
```
### Applying

Now that Terraform is setup check that the configuration is valid:

```
terraform validate 
```

To get a complete list of the different resources Terraform will create to achieve the state described in the configuration files you just wrote, run :

```
terraform plan
```

If the configuration is valid then apply it with:

```
terraform apply [-auto-approve]
```

Inspect the output of apply to ensure that what Terraform is going to do what you want, if so then enter `yes` at the prompt.
The infrastructure will then be created, this make take a some time.


### Clean Up

Remove the infrastructure created by Terraform with:

```
terraform destroy [-auto-approve]
rm -rf .terraform
```

Sometimes Terraform may report a failure to destroy some resources due to dependencies and timing contention.
In this case wait a few seconds and run the above command again. If it is still unable to remove everything it may be necessary to remove resources manually using the `gcloud` command or the Cloud Console.

The GCS Bucket used for Terraform state storage can be removed with:

```
gsutil rm -r gs://[BUCKET]
```
<!-- other.md -->
<!-- END_TF_DOCS -->