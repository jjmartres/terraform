terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    google-beta = {
      source = "hashicorp/google-beta"
    }
    null = {
      source = "hashicorp/null"
    }
  }
  required_version = ">= 0.13"
}
