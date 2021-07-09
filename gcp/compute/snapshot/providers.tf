provider "google" {
  version = "~> 3.10.0"
  project = var.project
  region = "${element(split("-", var.location),0)}-${element(split("-", var.location),1)}"
}

provider "google-beta" {
  project = var.project
  region = "${element(split("-", var.location),0)}-${element(split("-", var.location),1)}"
}