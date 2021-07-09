<!-- BEGIN_TF_DOCS -->

# Azure regions module

This terraform module is designed to help in using the AzureRM terraform provider.

It converts the Azure region given in slug format to the Azure standard format and a short format used for resource naming.
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

No providers.
## Usage
Basic usage of this submodule is as follows:

```hcl
module "az_region" {
  source = "git::git@github.com:a3bc/devops.git//terraform/acr/base/regions?ref=master"
 
  azure_region = "eu-west"
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
| <a name="input_azure_region"></a> [azure\_region](#input\_azure\_region) | Azure Region in slug format | `string` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_location"></a> [location](#output\_location) | Converted Azure region in standard format |
| <a name="output_location_cli"></a> [location\_cli](#output\_location\_cli) | Converted Azure region in Azure CLI name format |
| <a name="output_location_short"></a> [location\_short](#output\_location\_short) | Converted Azure region in short format for resource naming purpose |
# Other
## Azure regions mapping list

| Region name | Short notation | Internal terraform notation |
|-------------|----------------|-----------------------------|
| East US | ue | us-east |
| East US 2 | ue2 | us-east-2 |
| Central US | uc | us-central |
| North Central US | unc | us-north-central |
| South Central US | usc | us-south-central |
| West Central US | uwc | us-west-central |
| West US | uw | us-west |
| West US 2 | uw2 | us-west-2 |
| Canada East | cae | can-east |
| Canada Central | cac | can-central |
| Brazil South | brs | bra-south |
| North Europe | eun | eu-north |
| West Europe | euw | eu-west |
| France Central | frc | fr-central |
| France South | frs | fr-south |
| UK West | ukw | uk-west |
| UK South | uks | uk-south |
| Germany Central | gce | ger-central |
| Germany Northeast | gne | ger-north-east |
| Germany North | gno | ger-north |
| Germany West Central | gwc | ger-west-central |
| Switzerland North | swn | swz-north |
| Switzerland West | sww | swz-west |
| Norway East | noe | norw-east |
| Norway West | now | norw-west |
| Southeast Asia | ase | asia-south-east |
| East Asia | ae | asia-east |
| Australia East | aue | aus-east |
| Australia Southeast | ause | aus-south |
| Australia Central | auc | aus-central |
| Australia Central 2 | auc2 | aus-central-2 |
| China East | cne | cn-east |
| China North | cnn | cn-north |
| China East 2 | cne2 | cn-east-2 |
| China North 2 | cnn2 | cn-north-2 |
| Central India | inc | ind-central |
| West India | inw | ind-west |
| South India | ins | ind-south |
| Japan East | jpe | jap-east |
| Japan West | jpw | jap-west |
| Korea Central | krc | kor-central |
| Korea South | krs | kor-south |
| South Africa West | saw | saf-west |
| South Africa North | san | saf-north |
| UAE Central | uaec | uae-central |
| UAE North | uaen | uae-north |
| US Gov Virginia | govv | - |
| US Gov Iowa | govi | - |
| US Gov Arizona | gova | - |
| US Gov Texas | govt | - |
| US DoD East | gove | - |
| US DoD Central | govc | - |
| US Sec East | gove2 | - |
| US Sec West | gow | - |

| Internal terraform notation | Azure CLI name | Region name |
|-----------------------------|----------------|-------------|
us-east          | eastus             | East US
us-east-2        | eastus2            | East US 2
us-south-central | southcentralus     | South Central US
us-west-2        | westus2            | West US 2
aus-east         | australiaeast      | Australia East
asia-south-east  | southeastasia      | Southeast Asia
eu-north         | northeurope        | North Europe
uk-south         | uksouth            | UK South
eu-west          | westeurope         | West Europe
us-central       | centralus          | Central US
us-north-central | northcentralus     | North Central US
us-west          | westus             | West US
saf-north        | southafricanorth   | South Africa North
ind-central      | centralindia       | Central India
asia-east        | eastasia           | East Asia
jap-east         | japaneast          | Japan East
kor-central      | koreacentral       | Korea Central
can-central      | canadacentral      | Canada Central
fr-central       | francecentral      | France Central
ger-west-central | germanywestcentral | Germany West Central
norw-east        | norwayeast         | Norway East
swz-north        | switzerlandnorth   | Switzerland North
uae-north        | uaenorth           | UAE North
bra-south        | brazilsouth        | Brazil South
asia             | asia               | Asia
asia-pa          | asiapacific        | Asia Pacific
aus              | australia          | Australia
bra              | brazil             | Brazil
can              | canada             | Canada
eu               | europe             | Europe
global           | global             | Global
ind              | india              | India
jap              | japan              | Japan
uk               | uk                 | United Kingdom
us               | unitedstates       | United States
us-west-central  | westcentralus      | West Central US
saf-west         | southafricawest    | South Africa West
aus-central      | australiacentral   | Australia Central
aus-central-2    | australiacentral2  | Australia Central 2
aus-south-east   | australiasoutheast | Australia Southeast
jap-west         | japanwest          | Japan West
kor-south        | koreasouth         | Korea South
ind-south        | southindia         | South India
ind-west         | westindia          | West India
can-east         | canadaeast         | Canada East
fr-south         | francesouth        | France South
ger-north        | germanynorth       | Germany North
norw-west        | norwaywest         | Norway West
swz-west         | switzerlandwest    | Switzerland West
uk-west          | ukwest             | UK West
uae-central      | uaecentral         | UAE Central
bra-south-east   | brazilsoutheast    | Brazil Southeast
ger-north-east   | germanynortheast   | Germany Northeast
ger-central      | germanycentral     | Germany Central
cn-north   | chinanorth  | China North
cn-east    | chinaeast   | China East
cn-east-2  | chinaeast2  | China East 2
cn-north-2 | chinanorth2 | China North 2
<!-- END_TF_DOCS -->