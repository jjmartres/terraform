## Usage
Basic usage of this submodule is as follows:

```hcl
module "dd_syn_api_ssl
  source = "git::git@github.com:jjmartres/terraform.git//datadog/synthetics/api-ssl?ref=master"

  name = "Test of ssl validity"
  status = "live"
  tags = [
    "env:test",
    "foo"
  ]
  host = "zorglub.com"
  port = 443
  operator = "isInLessThan"
  period = 15
  message = "@slack-Zorglub-monitoring"
  tick_every = 1800
  accept_self_signed = false
  locations = [
    "aws:ap-northeast-1",
    "aws:ap-northeast-2",
    "aws:ap-south-1",
    "aws:ap-southeast-1",
    "aws:ap-southeast-2",
    "aws:ca-central-1",
    "aws:eu-central-1",
    "aws:eu-west-1",
    "aws:eu-west-2",
    "aws:sa-east-1",
    "aws:us-east-2",
    "aws:us-west-1",
    "aws:us-west-2"
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