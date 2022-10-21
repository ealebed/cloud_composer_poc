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
  default     = "composer-2.0.28-airflow-2.3.3"
}

variable "scheduler" {
  type = object({
    cpu        = number
    memory_gb  = number
    storage_gb = number
    count      = number
  })
  default = {
    cpu        = 0.5
    memory_gb  = 1
    storage_gb = 2
    count      = 1
  }
  description = "Configuration for resources used by Airflow scheduler"
}

variable "web_server" {
  type = object({
    cpu        = number
    memory_gb  = number
    storage_gb = number
  })
  default = {
    cpu        = 0.5
    memory_gb  = 1
    storage_gb = 2
  }
  description = "Configuration for resources used by Airflow web server"
}

variable "worker" {
  type = object({
    cpu        = number
    memory_gb  = number
    storage_gb = number
    min_count  = number
    max_count  = number
  })
  default = {
    cpu        = 1
    memory_gb  = 1
    storage_gb = 2
    min_count  = 1
    max_count  = 3
  }
  description = "Configuration for resources used by Airflow workers"
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

variable "gcp_sa_composer_roles" {
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

variable "gcp_sa_gcr_cleaner_roles" {
  type        = set(string)
  description = "List Roles to assign to GCR-cleaner Service account"
  default     = [
      "roles/artifactregistry.repoAdmin",
      "roles/iam.serviceAccountUser"
  ]
}
