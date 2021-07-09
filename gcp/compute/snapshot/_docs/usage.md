## Usage
Basic usage of this submodule is as follows:

```hcl
module "gcp_compute_snqpshot" {
  source = "git::git@github.com:jjmartres/terraform.git//gcp/compute/snapshot?ref=master"

  project            = "test-purpose-to-delete"
  location           = "europe-west1-c"
  policy_name_prefix = "plop"
  weekly_schedule = [{
    day = "monday",
    start_time = "04:00"
  }]
  max_retention_days = 7
  on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
  labels = { 
    key1 = "value1", 
    key2 = "value2" 
  }
  guest_flush = false
  disks_to_attach = [ 
    "plop-001", 
    "plop-002"
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