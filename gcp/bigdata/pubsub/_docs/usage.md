## Usage
Basic usage of this submodule is as follows:

```hcl
module "gcp_pubsub" {
  source  = "git::git@github.com:jjmartres/terraform.git//gcp/bigdata/pubsub?ref=master"

  topic      = "tf-topic"
  project_id = "my-pubsub-project"
  push_subscriptions = [
    {
      name                       = "push"                                               // required
      ack_deadline_seconds       = 20                                                   // optional
      push_endpoint              = "https://example.com"                                // required
      x-goog-version             = "v1beta1"                                            // optional
      oidc_service_account_email = "sa@example.com"                                     // optional
      audience                   = "example"                                            // optional
      expiration_policy          = "1209600s"                                           // optional
      dead_letter_topic          = "projects/my-pubsub-project/topics/example-dl-topic" // optional
      max_delivery_attempts      = 5                                                    // optional
      maximum_backoff            = "600s"                                               // optional
      minimum_backoff            = "300s"                                               // optional
      filter                     = "attributes.domain = \"com\""                        // optional
      enable_message_ordering    = true                                                 // optional
    }
  ]
  pull_subscriptions = [
    {
      name                    = "pull"                                               // required
      ack_deadline_seconds    = 20                                                   // optional
      dead_letter_topic       = "projects/my-pubsub-project/topics/example-dl-topic" // optional
      max_delivery_attempts   = 5                                                    // optional
      maximum_backoff         = "600s"                                               // optional
      minimum_backoff         = "300s"                                               // optional
      filter                  = "attributes.domain = \"com\""                        // optional
      enable_message_ordering = true                                                 // optional
      service_account         = "service2@project2.iam.gserviceaccount.com"          // optional
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