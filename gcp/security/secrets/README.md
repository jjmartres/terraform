<!-- BEGIN_TF_DOCS -->
# Google Cloud Secret Manager

A Secret is a logical secret whose value and versions can be accessed. This module will allow to manage secrets.
## Repository

[https://github.com/terraform/-/tree/master/gcp/security/secrets](https://github.com/terraform/-/tree/master/gcp/security/secrets)

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
 gcloud projects add-iam-policy-binding [project] --member serviceAccount:terraform@[project].iam.gserviceaccount.com --role roles/secretmanager.admin
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
| <a name="input_data"></a> [data](#input\_data) | The secret data. Must be no larger than `64KiB`. This property is sensitive and will not be displayed in the plan. | `string` | n/a | yes |
| <a name="input_id"></a> [id](#input\_id) | This must be unique within the project. | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | The key/value labels for the resource. | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | The location (region or zone) in which the resource will be created. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The project ID to manage the resources | `string` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Identifier for the secret. Format: `projects/{{project}}/secrets/{{secret_id}}` |
| <a name="output_name"></a> [name](#output\_name) | The resource name of the Secret. Format: `projects/{{project}}/secrets/{{secret_id}}` |
| <a name="output_version"></a> [version](#output\_version) | The resource name of the SecretVersion. Format: `projects/{{project}}/secrets/{{secret_id}}/versions/{{version}}` |
## Usage
Basic usage of this submodule is as follows:
```hcl
module "gcp_secrets_manager" {
    source = "git::git@github.com:jjmartres/terraform.git//gcp/security/secrets?ref=master"

    project = "arctic-math-252409"
    location = "europe-west1-c"
    id = "my-secret-id"
    data = "fukdhfukewhfshvsdjkhfrusfhrfhreu"
    labels = {
      app: "plop"
    }
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