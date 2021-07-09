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

module "acr" {
  source = "git::git@github.com:a3bc/devops.git//terraform/azurerm/acr?ref=master"

  location            = module.region.location
  location_short      = module.region.location_short
  resource_group_name = module.rg.resource_group_name
  sku                 = "Standard"

  client_name  = var.client_name
  environment  = var.environment
}
```