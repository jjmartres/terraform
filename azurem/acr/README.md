<!-- BEGIN_TF_DOCS -->

# Azure Container Registry

This Terraform module creates an [Azure Container Registry](https://docs.microsoft.com/en-us/azure/container-registry/).
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
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_enabled"></a> [admin\_enabled](#input\_admin\_enabled) | Specifies whether the admin user is enabled. | `bool` | `false` | no |
| <a name="input_client_name"></a> [client\_name](#input\_client\_name) | Client name/account used in naming | `string` | n/a | yes |
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | Custom Azure Container Registry name, generated if not set | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Project environment | `string` | n/a | yes |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Additional tags to associate with your Azure Container Registry. | `map(string)` | `{}` | no |
| <a name="input_georeplication_locations"></a> [georeplication\_locations](#input\_georeplication\_locations) | A list of Azure locations where the container registry should be geo-replicated. | `list(string)` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region to use | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Short string for Azure location | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Optional prefix for Azure Container Registry name | `string` | `""` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | The SKU name of the the container registry. Possible values are Classic (which was previously Basic), Basic, Standard and Premium. | `string` | `"Standard"` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acr_fqdn"></a> [acr\_fqdn](#output\_acr\_fqdn) | The Container Registry FQDN. |
| <a name="output_acr_id"></a> [acr\_id](#output\_acr\_id) | The Container Registry ID. |
| <a name="output_acr_name"></a> [acr\_name](#output\_acr\_name) | The Container Registry name. |
| <a name="output_admin_password"></a> [admin\_password](#output\_admin\_password) | The Password associated with the Container Registry Admin account - if the admin account is enabled. |
| <a name="output_admin_username"></a> [admin\_username](#output\_admin\_username) | The Username associated with the Container Registry Admin account - if the admin account is enabled. |
| <a name="output_login_server"></a> [login\_server](#output\_login\_server) | The URL that can be used to log into the container registry. |
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
## Related documentation

Terraform resource documentation: [terraform.io/docs/providers/azurerm/r/container_registry.html](https://www.terraform.io/docs/providers/azurerm/r/container_registry.html)
<!-- END_TF_DOCS -->