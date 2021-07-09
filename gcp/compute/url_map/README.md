<!-- BEGIN_TF_DOCS -->

# Google Cloud Compute URL map

This module is used to create an manage Google Cloud Compute URL map
## Repository

[https://github.com/terraform/-/tree/master/gcp/compute/url_map](https://github.com/terraform/-/tree/master/gcp/compute/url_map)

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
| <a name="input_default_service"></a> [default\_service](#input\_default\_service) | (Optional) The backend service or backend bucket to use when none of the given rules match. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | (Optional) An optional description of this resource. Provide this property when you create the resource. | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location (region or zone) in which the cluster master will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name of the resource. Provided by the client when the resource is created. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | (Required) The default project to manage resources in. | `string` | n/a | yes |
| <a name="input_rules"></a> [rules](#input\_rules) | (Optional) Rule to use against the URL:<br>    - `hosts`: (Required) The list of host patterns to match. They must be valid hostnames, except * will match any string of ([a-z0-9-.]*). In that case, * must be the first character and must be followed in the pattern by either - or ..<br>    - `path_matcher`: (Required) The name of the PathMatcher to use to match the path portion of the URL if the hostRule matches the URL's host portion.<br>    - `default_service`: (Optional) The backend service or backend bucket to use when none of the given paths match.<br>    - `paths`:  (Required) The list of path patterns to match. Each must start with / and the only place a is allowed is at the end following a /. The string fed to the path matcher does not include any text after the first ? or #, and those chars are not allowed here.<br>    - `service`: (Optional) The backend service or backend bucket to use if any of the given paths match.<pre>rules = [{<br>        hosts = ["mysite.com"],<br>        path_matcher = "mysite",<br>        default_service = "google_compute_backend_service.home.self_link"<br>        path_rules = [{<br>            "paths" = ["/home"],<br>            "service" = "google_compute_backend_service.home.self_link"<br>          },<br>          { "paths" = ["/login"],<br>            "service" = "google_compute_backend_service.login.self_link"<br>          },<br>          { "paths" = ["/static"],<br>            "service" = "google_compute_backend_service.static.self_link"<br>          }]<br>      }]</pre> | <pre>list(object({<br>    hosts = list(string),<br>    path_matcher = string,<br>    description = string,<br>    default_service = string,<br>    path_rules = list(object({<br>      paths = list(string)<br>      service = string<br>    }))<br>  }))</pre> | `[]` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_self_link"></a> [self\_link](#output\_self\_link) | The self link of the url\_map created |
## Usage
Basic usage of this submodule is as follows:

```hcl
module "gcp_compute_urlmap" {
  source = "git::git@github.com:jjmartres/terraform.git//gcp/compute/url_map?ref=master"

  project            = "test-purpose-to-delete"
  location           = "europe-west1-c"
  name               = "my-sample-url-map"
  description        = "My super URL map description"
  default_service    = "https://www.googleapis.com/compute/v1/projects/test-purpose-to-delete/global/backendServices/k8s-be-31541--690013e2b38368d1"
  rules = [{
      hosts = ["mysite.com"],
      path_matcher = "mysite",
      default_service = "https://www.googleapis.com/compute/v1/projects/test-purpose-to-delete/global/backendServices/k8s-be-31541--690013e2b38368d1"
      path_rules = [{
          paths = ["/home"],
          service = "https://www.googleapis.com/compute/v1/projects/test-purpose-to-delete/global/backendServices/k8s-be-31541--690013e2b38368d1"
        },
        { paths = ["/login"],
          service = "https://www.googleapis.com/compute/v1/projects/test-purpose-to-delete/global/backendServices/k8s-be-31541--690013e2b38368d1"
        },
        { paths = ["/static"],
          service = "https://www.googleapis.com/compute/v1/projects/test-purpose-to-delete/global/backendServices/k8s-be-31541--690013e2b38368d1"
        }]
    }]
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