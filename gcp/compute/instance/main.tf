/**
  *
  * # Google Cloud Compute instance
  *
  * This module is used to create an manage Google Cloud Compute instance
  */
variable "module_depends_on" {
  default = [""]
}

resource "null_resource" "module_depends_on" {
  triggers = {
    value = length(var.module_depends_on)
  }
}

resource "google_compute_address" "instances_public_ip" {
  count = var.instances_count
  name = "${var.instances_name_prefix}-${format("%03d", count.index + 1)}-address"
}

resource "google_compute_instance" "instances" {
  count = var.instances_count
  machine_type = var.machine_type
  name = "${var.instances_name_prefix}-${format("%03d", count.index + 1)}"
  project = var.project
  zone = var.location
  description = var.project_description == "" ? "Deployed by Terraform" : var.project_description

  boot_disk {
    auto_delete = var.auto_delete
    initialize_params {
      image = var.image_name
      type = var.disk_type
      size = var.disk_size_gb
    }
  }

  tags = concat(
  [
    "${var.instances_name_prefix}-${format("%03d", count.index + 1)}"],
  var.instances_tags
  )

  network_interface {
    network = var.network
    access_config {
      nat_ip = element(google_compute_address.instances_public_ip.*.address, count.index)
    }
  }

  metadata_startup_script = var.startup_script

  depends_on                       = [ null_resource.module_depends_on]
}