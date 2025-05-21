terraform {
  required_providers {
    google = {
        source = "hashicorp/google"
        version = "6.35.0"
    }
  }
}

locals {
  ssh_user = "terrform"
  ssh_key = file("~/.ssh/id_rsa.pub")

}

provider "google" {
    project = "root-fort-451407-c0"
    region = "asia-southeast1"
}

resource "google_compute_network" "vpc-iac" {
    name = "vpc-iac"
    auto_create_subnetworks = false  
}

resource "google_compute_subnetwork" "vpc-iac-subnet" {
    name = "vpc-iac-subnet"
    ip_cidr_range = "10.10.0.0/16"
    region = var.region
    network = google_compute_network.vpc-iac.id
}

resource "google_compute_instance" "cicd-instance" {
    count = 2
    name = "cicd-instance-${count.index+1}"
    machine_type = "e2-medium"
    zone = var.zone

    boot_disk {
      initialize_params {
        image = "ubuntu-os-cloud/ubuntu-2004-lts"
      }
    }

    network_interface {
      network = google_compute_network.vpc-iac.id
      subnetwork = google_compute_subnetwork.vpc-iac-subnet.id
      access_config {
        
      }
    }

    metadata = {
        ssh_key = "${local.ssh_user}:${local.ssh_key}"
        
    }

    tags = [ "jenkins" ]
}

resource "google_compute_firewall" "allowed-prts" {
    name = "iac-firewall-rules"
    network = google_compute_network.vpc-iac.name

    allow {
        protocol = "tcp"
        ports = [ "22", "80", "443" ]
    }

    direction = "INGRESS"
    source_ranges = ["0.0.0.0/0"]
    target_tags = ["jenkins"]

    description = "Allowed ports 22 80 443 from anywhere"
}

# resource "google_compute_instance" "vm1" {
#     provider = google
#     machine_type = "e2-medium"
#     zone = "asia-southeast1-a"
#     tags = ["vm", "cicd"]

#     boot_disk {
#         initialize_params {
#           image = 
#         }
      
#     }
# }

