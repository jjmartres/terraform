<!-- BEGIN_TF_DOCS -->

# Azure Resource Group

Common Azure terraform module to create a Resource Group  with optional lock.
## Repository

### Clone with SSH
Use a password-protected SSH key.
```bash
git clone git@github.com:a3bc/devops.git
```

###  Clone with HTTP
Use Git or checkout with SVN using the web URL.
```bash
git clone https://github.com/a3bc/devops.git
```

### GitHub CLI
Work fast with the official CLI. [Learn more](https://cli.github.com/).
```bash
gh repo clone a3bc/devops
```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
## Usage
Basic usage of this submodule is as follows:

```hcl
module "az_rg" {
  source = "git::git@github.com:a3bc/devops.git//terraform/acr/base/rg?ref=master"
  location = "fr-central"
  name = "my-sample-rg"
  tags = {
    "env": "test",
    "role": "resource_group"
 }
 lock_level = "ReadOnly"
}
```
### Setup
The following guide assumes commands are run from the `local` directory.

Provide the input variables with a `variables.auto.tfvars` file which can be created from the example file provided:

```bash
cp variables.auto.tfvars.example variables.auto.tfvars
```

The values set in this file should be edited according to your environment and requirements.

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
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | The Azure Region where the Resource Group should exist. Changing this forces a new Resource Group to be created. | `string` | n/a | yes |
| <a name="input_lock_level"></a> [lock\_level](#input\_lock\_level) | Specifies the Level to be used for this RG Lock. Possible values are Empty (no lock), CanNotDelete and ReadOnly. | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | The Name which should be used for this Resource Group. Changing this forces a new Resource Group to be created. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags which should be assigned to the Resource Group. | `map(string)` | `{}` | no |
| <a name="input_timeout_create"></a> [timeout\_create](#input\_timeout\_create) | Used when creating the Resource Group. | `string` | `"90m"` | no |
| <a name="input_timeout_delete"></a> [timeout\_delete](#input\_timeout\_delete) | Used when deleting the Resource Group. | `string` | `"90m"` | no |
| <a name="input_timeout_read"></a> [timeout\_read](#input\_timeout\_read) | Used when retrieving the Resource Group. | `string` | `"5m"` | no |
| <a name="input_timeout_update"></a> [timeout\_update](#input\_timeout\_update) | Used when updating the Resource Group. | `string` | `"90m"` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_group_id"></a> [resource\_group\_id](#output\_resource\_group\_id) | Resource group generated id |
| <a name="output_resource_group_location"></a> [resource\_group\_location](#output\_resource\_group\_location) | Resource group location (region) |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Resource group name |
## Related documentation

Terraform Azure RG documentation: [terraform.io/docs/providers/azurerm/r/resource_group.html](https://www.terraform.io/docs/providers/azurerm/r/resource_group.html)

Terraform Lock management documentation: [terraform.io/docs/providers/azurerm/r/management_lock.html](https://www.terraform.io/docs/providers/azurerm/r/management_lock.html)
<!-- END_TF_DOCS -->