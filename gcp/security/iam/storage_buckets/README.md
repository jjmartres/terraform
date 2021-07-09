<!-- BEGIN_TF_DOCS -->
# Google Cloud Storage Bucket IAM

This module is used is used to assign storage\_bucket roles.
## Repository

[https://github.com/terraform/-/tree/master/gcp/security/iam/storage_buckets](https://github.com/terraform/-/tree/master/gcp/security/iam/storage_buckets)

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
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable compute.googleapis.com
```

Now create a service account for Terraform to use, generate a key file for it, and save the key location as an environment variable:

```bash
gcloud iam service-accounts create terraform --display-name "Terraform, Infrastructure as Code"
gcloud projects add-iam-policy-binding [project] --member serviceAccount:terraform@[project].iam.gserviceaccount.com --role role/iam.roleAdmin
gcloud projects add-iam-policy-binding [project] --member serviceAccount:terraform@[project].iam.gserviceaccount.com --role roles/storage.admin
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
| <a name="input_bindings"></a> [bindings](#input\_bindings) | Map of role (key) and list of members (value) to add the IAM policies/bindings | `map(list(string))` | `{}` | no |
| <a name="input_conditional_bindings"></a> [conditional\_bindings](#input\_conditional\_bindings) | List of maps of role and respective conditions, and the members to add the IAM policies/bindings | <pre>list(object({<br>    role        = string<br>    title       = string<br>    description = string<br>    expression  = string<br>    members     = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | The location (region or zone) in which the instance will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the instance will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well | `string` | n/a | yes |
| <a name="input_mode"></a> [mode](#input\_mode) | Mode for adding the IAM policies/bindings, additive and authoritative | `string` | `"additive"` | no |
| <a name="input_project"></a> [project](#input\_project) | The project ID to manage the resources | `string` | n/a | yes |
| <a name="input_storage_buckets"></a> [storage\_buckets](#input\_storage\_buckets) | Storage Buckets list to add the IAM policies/bindings | `list(string)` | `[]` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_members"></a> [members](#output\_members) | Members which were bound to the Storage Bucket. |
| <a name="output_roles"></a> [roles](#output\_roles) | Roles which were assigned to members. |
| <a name="output_storage_buckets"></a> [storage\_buckets](#output\_storage\_buckets) | Storage Buckets which received bindings. |
## Usage
Basic usage of this submodule is as follows:

```hcl
module "storage_bucket-iam-bindings" {
  source = "git::git@github.com:jjmartres/terraform.git//gcp/iam/storage_buckets?ref=master"
    
    storage_buckets = ["my-storage_bucket_one", "my-storage_bucket_two"]
    mode            = "additive"
    
    bindings = {
    "roles/storage.legacyBucketReader" = [
      "serviceAccount:my-sa@my-project.iam.gserviceaccount.com",
      "group:my-group@my-org.com",
      "user:my-user@my-org.com",
      ],
    "roles/storage.legacyBucketWriter" = [
      "serviceAccount:my-sa@my-project.iam.gserviceaccount.com",
      "group:my-group@my-org.com",
      "user:my-user@my-org.com",
      ]
    }
    conditional_bindings = [
        {
          role = "roles/storage.admin"
          title = "expires_after_2019_12_31"
          description = "Expiring at midnight of 2019-12-31"
          expression = "request.time < timestamp(\"2020-01-01T00:00:00Z\")"
          members = ["user:my-user@my-org.com"]
        }
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