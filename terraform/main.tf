terraform {
  required_version = "~> 1.0"
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

data "google_project" "project" {}

data "google_client_config" "current" {}

data "google_container_cluster" "composer_cluster" {
  name     = reverse(split("/",google_composer_environment.test.config.0.gke_cluster))[0]
  location = var.gcp_region
}

provider "kubernetes" {
  host                   = format("https://%s", data.google_container_cluster.composer_cluster.endpoint)
  token                  = data.google_client_config.current.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.composer_cluster.master_auth[0].cluster_ca_certificate,
  )
}

# Random string added as a suffix to make a unique resources name
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}
