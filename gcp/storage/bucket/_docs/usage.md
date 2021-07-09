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