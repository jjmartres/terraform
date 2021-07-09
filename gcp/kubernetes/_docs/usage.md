## Usage
Basic usage of this submodule is as follows:

```hcl
module "gcp_gke" {
  source = "git::git@github.com:jjmartres/terraform.git//gcp/kubernetes?ref=master"

  project               = "test-purpose-to-delete"
  location              = "europe-west1-c"
  bucket                = "arctic-math-252409-ias"
  bucket_prefix         = "instance/state"
  name                  = "my-super-cluster"
  description           = "my-super-description"
  node_pools            = 3
  initial_node_count    = 3
  min_node_count        = 1
  max_node_count        = 3
  machine_type          = "n1-standard-1"
  disk_type             = "pd-standard"
  disk_size_gb          = 100
  network               = "default"
  tags                  =  [ "infrastructure", "terraform", "test"]
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