## Usage
Basic usage of this submodule is as follows:

```hcl
module "peering" {
  source = "git::git@github.com:jjmartres/terraform.git//gcp/network/network-peering?ref=master"

  prefix        = "name-prefix"
  local_network = "<FIRST NETWORK SELF LINK>"
  peer_network  = "<SECOND NETWORK SELF LINK>"
}
```
If you need to create more than one peering for the same VPC Network `(A -> B, A -> C)` you have to use output from the first module as a dependency for the second one to keep order of peering creation (It is not currently possible to create more than one peering connection for a VPC Network at the same time).

```hcl
module "peering-a-b" {
  source = "git::git@github.com:jjmartres/terraform.git//gcp/network/network-peering?ref=master"

  prefix        = "name-prefix"
  local_network = "<A NETWORK SELF LINK>"
  peer_network  = "<B NETWORK SELF LINK>"
}

module "peering-a-c" {
  source = "git::git@github.com:jjmartres/terraform.git//gcp/network/network-peering?ref=master"

  prefix        = "name-prefix"
  local_network = "<A NETWORK SELF LINK>"
  peer_network  = "<C NETWORK SELF LINK>"

  module_depends_on = [module.peering-a-b.complete]
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