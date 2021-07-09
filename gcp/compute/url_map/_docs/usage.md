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