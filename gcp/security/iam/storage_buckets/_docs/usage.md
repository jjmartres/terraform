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