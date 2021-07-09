<!-- BEGIN_TF_DOCS -->

# Google BigData PubSub

This module makes it easy to create Google Cloud Pub/Sub topic and subscriptions associated with the topic.
## Repository

[https://github.com/terraform/-/tree/master/gcp/bigdata/pubsub](https://github.com/terraform/-/tree/master/gcp/bigdata/pubsub)

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

Now create a service account for Terraform to use, generate a key file for it, and save the key location as an environment variable:

```bash
gcloud iam service-accounts create terraform --display-name "Terraform, Infrastructure as Code"
gcloud projects add-iam-policy-binding [project] --member serviceAccount:terraform@[project].iam.gserviceaccount.com --role roles/pubsub.admin
gcloud iam service-accounts keys create terraform.json --iam-account terraform@[project].iam.gserviceaccount.com
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
| <a name="input_create_topic"></a> [create\_topic](#input\_create\_topic) | Specify true if you want to create a topic | `bool` | `true` | no |
| <a name="input_grant_token_creator"></a> [grant\_token\_creator](#input\_grant\_token\_creator) | Specify true if you want to add token creator role to the default Pub/Sub SA | `bool` | `true` | no |
| <a name="input_message_storage_policy"></a> [message\_storage\_policy](#input\_message\_storage\_policy) | A map of storage policies. Default - inherit from organization's Resource Location Restriction policy. | `map(any)` | `{}` | no |
| <a name="input_project"></a> [project](#input\_project) | The project ID to manage the Pub/Sub resources | `string` | n/a | yes |
| <a name="input_pull_subscriptions"></a> [pull\_subscriptions](#input\_pull\_subscriptions) | The list of the pull subscriptions | `list(map(string))` | `[]` | no |
| <a name="input_push_subscriptions"></a> [push\_subscriptions](#input\_push\_subscriptions) | The list of the push subscriptions | `list(map(string))` | `[]` | no |
| <a name="input_subscription_labels"></a> [subscription\_labels](#input\_subscription\_labels) | A map of labels to assign to every Pub/Sub subscription | `map(string)` | `{}` | no |
| <a name="input_topic"></a> [topic](#input\_topic) | The Pub/Sub topic name | `string` | n/a | yes |
| <a name="input_topic_kms_key_name"></a> [topic\_kms\_key\_name](#input\_topic\_kms\_key\_name) | The resource name of the Cloud KMS CryptoKey to be used to protect access to messages published on this topic. | `string` | `null` | no |
| <a name="input_topic_labels"></a> [topic\_labels](#input\_topic\_labels) | A map of labels to assign to the Pub/Sub topic | `map(string)` | `{}` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Pub/Sub topic |
| <a name="output_subscription_names"></a> [subscription\_names](#output\_subscription\_names) | The name list of Pub/Sub subscriptions |
| <a name="output_subscription_paths"></a> [subscription\_paths](#output\_subscription\_paths) | The path list of Pub/Sub subscriptions |
| <a name="output_topic"></a> [topic](#output\_topic) | The name of the Pub/Sub topic |
| <a name="output_topic_labels"></a> [topic\_labels](#output\_topic\_labels) | Labels assigned to the Pub/Sub topic |
| <a name="output_uri"></a> [uri](#output\_uri) | The URI of the Pub/Sub topic |
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
<!-- other.md -->
<!-- END_TF_DOCS -->