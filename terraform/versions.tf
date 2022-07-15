terraform {
  required_version = ">=0.14"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.53, < 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  credentials = file("../credentials.json")

  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
}

provider "google-beta" {
  credentials = file("../credentials.json")

  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
}
