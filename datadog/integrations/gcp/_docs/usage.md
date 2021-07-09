## Usage
Basic usage of this submodule is as follows:

```hcl
module "dd_gcp_integrations" {
 source = "git::git@github.com:jjmartres/terraform.git//datadog/integrations/gcp?ref=master"

 project_id     = "awesome-project-id"
 private_key_id = "1234567890123456789012345678901234567890"
 private_key    = "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"
 client_email   = "awesome-service-account@awesome-project-id.iam.gserviceaccount.com"
 client_id      = "123456789012345678901"
 host_filters   = "foo:bar,buzz:lightyear"
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