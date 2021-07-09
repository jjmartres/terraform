## Usage
Basic usage of this submodule is as follows:
#### Custom Role at Organization Level
```hcl
module "custom-roles" {
    source = "git::git@github.com:jjmartres/terraform.git//gcp/iam/custom_roles?ref=master"
    
    target_level         = "org"
    target_id            = "123456789"
    role_id              = "custom_role_id"
    title                = "Custom Role Unique Title"
    description          = "Custom Role Description"
    base_roles           = ["roles/iam.serviceAccountAdmin"]
    permissions          = ["iam.roles.list", "iam.roles.create", "iam.roles.delete"]
    excluded_permissions = ["iam.serviceAccounts.setIamPolicy"]
    members              = ["user:user01@domain.com", "group:group01@domain.com"]
}
```
#### Custom Role at Project Level
```hcl
module "custom-roles" {
    source = "git::git@github.com:jjmartres/terraform.git//gcp/iam/custom_roles?ref=master"
    
    target_level         = "project"
    target_id            = "project_id_123"
    role_id              = "custom_role_id"
    title                = "Custom Role Unique Title"
    description          = "Custom Role Description"
    base_roles           = ["roles/iam.serviceAccountAdmin"]
    permissions          = ["iam.roles.list", "iam.roles.create", "iam.roles.delete"]
    excluded_permissions = ["iam.serviceAccounts.setIamPolicy"]
    members              = ["serviceAccount:member01@${var.target_id}.iam.gserviceaccount.com", "serviceAccount:member02@${var.target_id}.iam.gserviceaccount.com"]
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