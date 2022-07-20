terraform {
  required_version = ">=0.14"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }
}

provider "google" {
  # credentials = file("../credentials.json")

  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
}

provider "google-beta" {
  # credentials = file("../credentials.json")

  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
}

provider "kubernetes" {
  host                   = google_container_cluster.default.endpoint
  token                  = data.google_client_config.current.access_token
  client_certificate     = base64decode(
    google_container_cluster.default.master_auth[0].client_certificate,
  )
  client_key             = base64decode(google_container_cluster.default.master_auth[0].client_key)
  cluster_ca_certificate = base64decode(
    google_container_cluster.default.master_auth[0].cluster_ca_certificate,
  )
}
