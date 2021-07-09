<!-- BEGIN_TF_DOCS -->

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
module "region" {
  source = "git::git@github.com:a3bc/devops.git//terraform/azurerm/base/regions?ref=master"

  azure_region = var.location
}

module "rg" {
  source = "git::git@github.com:a3bc/devops.git//terraform/azurerm/base/rg?ref=master"

  location = module.region.location
  client_name  = var.client_name
  environment  = var.environment

  tags = {
    "env": "test",
    "role": "resource_group"
 }
}

module "servicebus" {
  source = "git::git@github.com:a3bc/devops.git//terraform/azurerm/servicebus/rg?ref=master"

  location       = module.region.location
  location_short = module.region.location_short
  client_name    = var.client_name
  environment    = var.environment

  resource_group_name = module.rg.resource_group_name

  servicebus_namespaces_queues = {
    # You can just create a servicebus_namespace
    servicebus0 = {}

    # Or create a servicebus_namespace with some queues with default values
    servicebus1 = {
      queues = {
        queue1 = {}
        queue2 = {}
      }
    }

    # Or customize everything
    servicebus2 = {
      custom_name = format("%s-%s-%s-custom", var.stack, var.client_name, module.azure-region.location_short)
      sku         = "Premium"
      capacity    = 2

      queues = {
        queue100 = {
          reader = true
          sender = true
          manage = true
        }
        queue200 = {
          dead_lettering_on_message_expiration = true
          default_message_ttl                  = "PT10M"
          reader                               = true
        }
        queue300 = {
          duplicate_detection_history_time_window = "PT30M"
          sender                                  = true
        }
        queue400 = {  
          requires_duplicate_detection = true
          manage                       = true
        }
      }
    }
  }
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
| <a name="input_client_name"></a> [client\_name](#input\_client\_name) | Client name/account used in naming | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Project environment | `string` | n/a | yes |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Extra tags to add | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure location for Servicebus. | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Short string for Azure location. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_servicebus_namespaces_queues"></a> [servicebus\_namespaces\_queues](#input\_servicebus\_namespaces\_queues) | Map to handle Servicebus creation. It supports the creation of the queues, authorization\_rule associated with each namespace you create | `any` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_manages"></a> [manages](#output\_manages) | Service Bus "managers" authorization rules map |
| <a name="output_namespaces"></a> [namespaces](#output\_namespaces) | Service Bus namespaces map |
| <a name="output_queues"></a> [queues](#output\_queues) | Service Bus queues map |
| <a name="output_readers"></a> [readers](#output\_readers) | Service Bus "readers" authorization rules map |
| <a name="output_senders"></a> [senders](#output\_senders) | Service Bus "sender" authorization rules map |
## Related documentation

Terraform resource documentation on Service Bus namespace: [terraform.io/docs/providers/azurerm/r/servicebus_namespace.html](https://www.terraform.io/docs/providers/azurerm/r/servicebus_namespace.html)

Terraform resource documentation on Service Bus queue: [terraform.io/docs/providers/azurerm/r/servicebus_queue.html](https://www.terraform.io/docs/providers/azurerm/r/servicebus_queue.html)

Microsoft Azure documentation: [docs.microsoft.com/en-us/azure/service-bus/](https://docs.microsoft.com/en-us/azure/service-bus/)
<!-- END_TF_DOCS -->