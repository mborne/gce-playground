provider "google" {
  project = var.project_id
  region  = var.region_name
}

resource "google_compute_network" "vpc_network" {
  name                    = "gcebox-network"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "default" {
  name          = "gcebox-network-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region_name
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_firewall" "ssh-rule" {
  name    = "gcebox-firewall-ssh"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags   = ["gcebox-firewall-ssh"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "default" {
  count = 3

  name = format("gcebox-%02d", count.index + 1)

  machine_type = "f1-micro"
  zone         = var.zone_name
  tags = [
    "gcebox-firewall-ssh"
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

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/hosts.tmpl",
    {
      box_hostnames  = google_compute_instance.default.*.name,
      zone_name  = var.zone_name,
      project_id = var.project_id
    }
  )
  filename = "${path.module}/inventory/hosts"
}
