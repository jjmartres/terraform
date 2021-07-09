/**
  *
  * # Azure regions module
  *
  * This terraform module is designed to help in using the AzureRM terraform provider.
  *
  * It converts the Azure region given in slug format to the Azure standard format and a short format used for resource naming.
  *
  */
locals {
  description = "Azure region mapping between slug and standard format."

  regions = {
    us-west          = "West US"
    us-west-2        = "West US 2"
    us-central       = "Central US"
    us-west-central  = "West Central US"
    us-south-central = "South Central US"
    us-north-central = "North Central US"
    us-east          = "East US"
    us-east-2        = "East US 2"
    can-central      = "Canada Central"
    can-east         = "Canada East"
    bra-south        = "Brasil South"
    bra-south-east   = "Brazil Southeast"
    uk-south         = "UK South"
    uk-west          = "UK West"
    eu-north         = "North Europe"
    eu-west          = "West Europe"
    fr-central       = "France Central"
    fr-south         = "France South"
    ger-north        = "Germany North"
    ger-north-east   = "Germany Northeast"
    ger-central      = "Germany Central"
    ger-west-central = "Germany West Central"
    swz-north        = "Switzerland North"
    swz-west         = "Switzerland West"
    norw-east        = "Norway East"
    norw-west        = "Norway West"
    saf-west         = "South Africa West"
    saf-north        = "South Africa North"
    ind-west         = "West India"
    ind-central      = "Central India"
    ind-south        = "South India"
    asia-south-east  = "Southeast Asia"
    asia-east        = "East Asia"
    cn-east          = "China East"
    cn-east-2        = "China East 2"
    cn-north         = "China North"
    cn-north-2       = "China North 2"
    kor-central      = "Korea Central"
    kor-south        = "Korea South"
    jap-east         = "Japan East"
    jap-west         = "Japan West"
    aus-central      = "Australia Central"
    aus-central-2    = "Australia Central 2"
    aus-east         = "Australia East"
    aus-south-east   = "Australia Southeast"
    uae-central      = "UAE Central" # United Arab Emirates
    uae-north        = "UAE North"   # United Arab Emirates

    # Global/continental zones
    "asia"    = "Asia"
    "asia-pa" = "Asia Pacific"
    "aus"     = "Australia"
    "bra"     = "Brazil"
    "can"     = "Canada"
    "eu"      = "Europe"
    "global"  = "Global"
    "ind"     = "India"
    "jap"     = "Japan"
    "uk"      = "United Kingdom"
    "us"      = "United States"
  }

  short_names = {
    "us-east"          = "ue"
    "us-east-2"        = "ue2"
    "us-central"       = "uc"
    "us-north-central" = "unc"
    "us-south-central" = "usc"
    "us-west-central"  = "uwc"
    "us-west"          = "uw"
    "us-west-2"        = "uw2"
    "can-east"         = "cae"
    "can-central"      = "cac"
    "bra-south"        = "brs"
    "bra-south-east"   = "brse" # Brazil Southeast
    "eu-north"         = "eun"
    "eu-west"          = "euw"
    "fr-central"       = "frc"
    "fr-south"         = "frs"
    "uk-west"          = "ukw"
    "uk-south"         = "uks"
    "ger-central"      = "gce"
    "ger-north-east"   = "gne"
    "ger-north"        = "gno"
    "ger-west-central" = "gwc"
    "swz-north"        = "swn"
    "swz-west"         = "sww"
    "norw-east"        = "noe"
    "norw-west"        = "now"
    "asia-south-east"  = "ase"
    "asia-east"        = "ae"
    "aus-east"         = "aue"
    "aus-south"        = "aus"
    "aus-central"      = "auc"
    "aus-central-2"    = "auc2"
    "cn-east"          = "cne"
    "cn-north"         = "cnn"
    "cn-east-2"        = "cne2"
    "cn-north-2"       = "cnn2"
    "ind-central"      = "inc"
    "ind-west"         = "inw"
    "ind-south"        = "ins"
    "jap-east"         = "jpe"
    "jap-west"         = "jpw"
    "kor-central"      = "krc"
    "kor-south"        = "krs"
    "saf-west"         = "saw"
    "saf-north"        = "san"
    "uae-central"      = "uaec"
    "uae-north"        = "uaen"

    # Global/continental zones
    "asia"    = "asia"   # Asia
    "asia-pa" = "asiapa" # Asia Pacific
    "aus"     = "aus"    # Australia
    "bra"     = "bra"    # Brazil
    "can"     = "can"    # Canada
    "eu"      = "eu"     # Europe
    "global"  = "glob"   # Global
    "ind"     = "ind"    # India
    "jap"     = "jap"    # Japan
    "uk"      = "uk"     # United Kingdom
    "us"      = "us"     # United States
  }

  # Thoses region CLI name where partially generated via
  # `az account list-locations --output json | jq -r '.[] | "\"\" = \"" + .name + "\" # " + .displayName'`
  cli_names = {
    "us-east"          = "eastus"             # East US
    "us-east-2"        = "eastus2"            # East US 2
    "us-south-central" = "southcentralus"     # South Central US
    "us-west-2"        = "westus2"            # West US 2
    "aus-east"         = "australiaeast"      # Australia East
    "asia-south-east"  = "southeastasia"      # Southeast Asia
    "eu-north"         = "northeurope"        # North Europe
    "uk-south"         = "uksouth"            # UK South
    "eu-west"          = "westeurope"         # West Europe
    "us-central"       = "centralus"          # Central US
    "us-north-central" = "northcentralus"     # North Central US
    "us-west"          = "westus"             # West US
    "saf-north"        = "southafricanorth"   # South Africa North
    "ind-central"      = "centralindia"       # Central India
    "asia-east"        = "eastasia"           # East Asia
    "jap-east"         = "japaneast"          # Japan East
    "kor-central"      = "koreacentral"       # Korea Central
    "can-central"      = "canadacentral"      # Canada Central
    "fr-central"       = "francecentral"      # France Central
    "ger-west-central" = "germanywestcentral" # Germany West Central
    "norw-east"        = "norwayeast"         # Norway East
    "swz-north"        = "switzerlandnorth"   # Switzerland North
    "uae-north"        = "uaenorth"           # UAE North
    "bra-south"        = "brazilsouth"        # Brazil South
    "asia"             = "asia"               # Asia
    "asia-pa"          = "asiapacific"        # Asia Pacific
    "aus"              = "australia"          # Australia
    "bra"              = "brazil"             # Brazil
    "can"              = "canada"             # Canada
    "eu"               = "europe"             # Europe
    "global"           = "global"             # Global
    "ind"              = "india"              # India
    "jap"              = "japan"              # Japan
    "uk"               = "uk"                 # United Kingdom
    "us"               = "unitedstates"       # United States
    "us-west-central"  = "westcentralus"      # West Central US
    "saf-west"         = "southafricawest"    # South Africa West
    "aus-central"      = "australiacentral"   # Australia Central
    "aus-central-2"    = "australiacentral2"  # Australia Central 2
    "aus-south-east"   = "australiasoutheast" # Australia Southeast
    "jap-west"         = "japanwest"          # Japan West
    "kor-south"        = "koreasouth"         # Korea South
    "ind-south"        = "southindia"         # South India
    "ind-west"         = "westindia"          # West India
    "can-east"         = "canadaeast"         # Canada East
    "fr-south"         = "francesouth"        # France South
    "ger-north"        = "germanynorth"       # Germany North
    "norw-west"        = "norwaywest"         # Norway West
    "swz-west"         = "switzerlandwest"    # Switzerland West
    "uk-west"          = "ukwest"             # UK West
    "uae-central"      = "uaecentral"         # UAE Central
    "bra-south-east"   = "brazilsoutheast"    # Brazil Southeast
    "ger-north-east"   = "germanynortheast"   # "Germany Northeast"
    "ger-central"      = "germanycentral"     # "Germany Central"

    "cn-north"   = "chinanorth"  # "China North"
    "cn-east"    = "chinaeast"   # "China East"
    "cn-east-2"  = "chinaeast2"  # "China East 2"
    "cn-north-2" = "chinanorth2" # "China North 2"
  }
}