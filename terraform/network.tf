resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "google_compute_network" "default" {
  name                    = "composer-test-${random_string.suffix.result}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name          = "composer-${random_string.suffix.result}"
  ip_cidr_range = "10.0.0.0/16"
  region        = var.gcp_region
  network       = google_compute_network.default.self_link

  secondary_ip_range {
    range_name    = "composer-pods-${random_string.suffix.result}"
    ip_cidr_range = "192.168.0.0/18"
  }

  secondary_ip_range {
    range_name    = "composer-services-${random_string.suffix.result}"
    ip_cidr_range = "192.168.64.0/18"
  }
}
