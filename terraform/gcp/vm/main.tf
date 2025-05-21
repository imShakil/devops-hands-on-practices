# This code is compatible with Terraform 4.25.0 and versions that are backward compatible to 4.25.0.
# For information about validating this Terraform code, see https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build#format-and-validate-the-configuration

resource "google_compute_instance" "mainserver" {
  boot_disk {
    auto_delete = true
    device_name = "mainserver"

    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-minimal-2404-noble-amd64-v20250514"
      size  = 25
      type  = "pd-standard"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = true
  enable_display      = false

  labels = {
    goog-ec-src           = "vm_add-tf"
    goog-ops-agent-policy = "v2-x86-template-1-4-0"
  }

  machine_type = "e2-standard-2"

  metadata = {
    enable-osconfig = "TRUE"
    ssh-keys        = "imshakil:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDBShfjJhjUxmE02Fb87bR7srrPdDxidu5W5Rb4nZrisul8kUqo5DVqst9KYJpZQSTVYdiFFYfwusIPEej0M06NiJhKsVf/8AlmdN6koqgVYcd9e+t3rEsHYWph5C6AEWIZqUx8CIIAuM1u+IPmiWCOiVCb30kTQoXXyVAauNU6+wtMseMjQ0hER9EYaweocUGzzOLEuvlArYgdrYhVgIYfFyhFv3+jnVOIu6ek8mU0RaVf9v3NaXZjrOMXHvHXQI0su1O+imvCVE8q9qxpzEO8BfJIc4jp5IUKojhIyCtb8YrlFkEp7CXQK+W8C6FewZVgYJX3sQqmoZFIMWrtoiZ7HtH4sLbflU+s6v0t428Us9tVawBihotGba+ctvch4i6n9yLTz82Cuktl8YCCWABh0fK22q5RiHSAQ/HxPLC6CJOisH3s/fwJoIgWPloYHz4OZieYZx8yY/SL/Mj5VFt2axFzILYuQ9dX60xzwmvYgnqLgkuNg7FbGKmcwWMtEMs= imshakil@Mobaraks-MacBook-Pro.local"
    startup-script  = "curl -fsSL https://test.docker.com -o test-docker.sh\nsudo sh test-docker.sh\n"
  }

  name = "mainserver"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/adroit-outlet-460307-c2/regions/us-central1/subnetworks/default"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "995161886552-compute@developer.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  tags = ["http-server", "https-server"]
  zone = "us-central1-f"
}

module "ops_agent_policy" {
  source          = "github.com/terraform-google-modules/terraform-google-cloud-operations/modules/ops-agent-policy"
  project         = "adroit-outlet-460307-c2"
  zone            = "us-central1-f"
  assignment_id   = "goog-ops-agent-v2-x86-template-1-4-0-us-central1-f"
  agents_rule = {
    package_state = "installed"
    version = "latest"
  }
  instance_filter = {
    all = false
    inclusion_labels = [{
      labels = {
        goog-ops-agent-policy = "v2-x86-template-1-4-0"
      }
    }]
  }
}
