variable "gcp_project" {
  type        = string
  description = "GCP project name"
  default     = ""
}

variable "gcp_region" {
  type        = string
  description = "GCP region name"
  default     = "europe-west1"
}

variable "gcp_zone" {
  type        = string
  description = "GCP zone name"
  default     = "europe-west1-b"
}

variable "gcp_composer_image" {
  type        = string
  description = "Name of the Cloud Composer image"
  default     = "composer-2.0.20-airflow-2.2.5"
}

variable "composer_dag_path" {
  type        = string
  description = "Path to composer DAG files"
  default     = "../dags/"
}

variable "result_bucket" {
  type        = string
  description = "GCS bucket to use for result of Hadoop job(s)"
  default     = ""
}

variable "gcp_apis" {
  type        = set(string)
  description = "List Google APIs to enable"
  default     = [
    "cloudresourcemanager.googleapis.com",
    "storage-api.googleapis.com",
    "serviceusage.googleapis.com",
    "composer.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "bigquery.googleapis.com",
    "iam.googleapis.com",
    "servicenetworking.googleapis.com",
    "cloudscheduler.googleapis.com",
    "cloudbuild.googleapis.com",
    "logging.googleapis.com"
  ]
}

variable "gcp_sa_roles" {
  type        = set(string)
  description = "List Roles to assign to Composer Service account"
  default     = [
    "roles/dataproc.editor",
    "roles/compute.networkAdmin",
    "roles/compute.instanceAdmin.v1",
    "roles/iam.serviceAccountUser",
    "roles/composer.worker",
    "roles/storage.objectViewer",
    "roles/container.developer",
    "roles/bigquery.dataOwner"
  ]
}
