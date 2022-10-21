# Configuration for VPC network/subnetwork resources on GCP

# Create VPC network for Cloud Composer
resource "google_compute_network" "default" {
  name                    = "network-composer-${random_string.suffix.result}"
  auto_create_subnetworks = false
}

# Create subnetwork for Cloud Composer with custom configurations for secondary IP ranges
# These IP ranges are enough to proper autoscaling in GKE under the hood of Cloud Composer
resource "google_compute_subnetwork" "default" {
  name          = "subnetwork-composer-${random_string.suffix.result}"
  ip_cidr_range = "10.0.0.0/16"
  region        = var.gcp_region
  network       = google_compute_network.default.self_link

  secondary_ip_range {
    range_name    = "ip-range-composer-pods-${random_string.suffix.result}"
    ip_cidr_range = "192.168.0.0/18"
  }

  secondary_ip_range {
    range_name    = "ip-range-composer-services-${random_string.suffix.result}"
    ip_cidr_range = "192.168.64.0/18"
  }
}
