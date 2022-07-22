data "google_container_cluster" "my_cluster" {
  name     = reverse(split("/",google_composer_environment.test.config.0.gke_cluster))[0]
  location = var.gcp_region
}

data "google_client_config" "current" {}

resource "random_id" "random_suffix" {
  byte_length = 2
}

resource "google_composer_environment" "test" {
  name   = "example-composer-${random_id.random_suffix.hex}"
  region = var.gcp_region

  config {
    software_config {
      image_version = var.gcp_composer_image

      airflow_config_overrides = {
        core-dags_are_paused_at_creation = "True"
      }

      # https://stackoverflow.com/questions/52809474/google-cloud-composer-variables-do-not-propagate-to-airflow/63348844#63348844
      env_variables = {
        AIRFLOW_VAR_GCP_PROJECT = var.gcp_project
        AIRFLOW_VAR_GCE_REGION  = var.gcp_region
        AIRFLOW_VAR_GCS_BUCKET  = var.result_bucket
      }
    }

    workloads_config {
      scheduler {
        cpu        = 2.5
        memory_gb  = 2.5
        storage_gb = 2
        count      = 1
      }
      web_server {
        cpu        = 1
        memory_gb  = 2.5
        storage_gb = 2
      }
      worker {
        cpu = 1
        memory_gb  = 2
        storage_gb = 2
        min_count  = 1
        max_count  = 3
      }
    }

    environment_size = "ENVIRONMENT_SIZE_SMALL"

    node_config {
      network         = google_compute_network.default.name
      subnetwork      = google_compute_subnetwork.default.name
      service_account = google_service_account.sa_composer.email
      ip_allocation_policy {
        cluster_secondary_range_name = google_compute_subnetwork.default.secondary_ip_range[0].range_name
        services_secondary_range_name = google_compute_subnetwork.default.secondary_ip_range[1].range_name
      }
    }
  }

  labels = {
    owner = "devops-team"
    env = "test"
  }

  depends_on = [
    google_project_iam_member.composer_agent_v2_role,
    google_project_service.services,
    google_compute_network.default,
    google_compute_subnetwork.default,
    google_service_account.sa_composer
  ]
}

# Upload example dag(s) to DAGs folder in Composer Bucket
resource "google_storage_bucket_object" "dag_init_upload" {
  for_each = fileset(var.composer_dag_path, "**")

  bucket = element(split("/dags", element(split("gs://", google_composer_environment.test.config.0.dag_gcs_prefix), 1)), 0)
  name   = "dags/${each.value}"
  source = "${var.composer_dag_path}${each.value}"

  depends_on = [
    google_composer_environment.test
  ]
}
