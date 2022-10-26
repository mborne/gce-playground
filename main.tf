variable "project_id" {
  type     = string
  nullable = false
}

variable "region_name" {
  type    = string
  default = "us-west1"
}

variable "zone_name" {
  type    = string
  default = "us-west1-a"
}


provider "google" {
  project = var.project_id
  region  = var.region_name
}

resource "google_compute_network" "vpc_network" {
  name                    = "gcpbox-network"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "default" {
  name          = "gcpbox-network-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region_name
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_firewall" "ssh-rule" {
  name    = "gcpbox-firewall-ssh"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags   = ["gcpbox-firewall-ssh"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "default" {
  count = 3

  name = format("gcpbox-%02d", count.index + 1)

  machine_type = "f1-micro"
  zone         = var.zone_name
  tags = [
    "gcpbox-firewall-ssh"
  ]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  # Install Flask
  metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python3-pip rsync; pip install flask"

  network_interface {
    subnetwork = google_compute_subnetwork.default.id

    access_config {
      # Include this section to give the VM an external IP address
    }
  }

}
