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