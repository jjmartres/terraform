provider "google" {
  project = var.project
  region = "${element(split("-", var.location),0)}-${element(split("-", var.location),1)}"
}

provider "google-beta" {
  project = var.project
  region = "${element(split("-", var.location),0)}-${element(split("-", var.location),1)}"
}