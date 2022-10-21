
# Configuration for an environment for running orchestration tasks.
# Environments run Apache Airflow software on Google infrastructure.

# Environment resource requires a long deployment process and involves several layers of GCP infrastructure,
# including a Kubernetes Engine cluster, Cloud Storage, and Compute networking resources.

# Read more:
# https://cloud.google.com/composer/docs/composer-2/create-environments
# https://cloud.google.com/composer/docs/composer-2/scale-environments
# https://cloud.google.com/composer/docs/composer-2/configure-shared-vpc
# http://airflow.apache.org/

# (!) Environments create Google Cloud Storage buckets that do not get cleaned up automatically on environment deletion
resource "google_composer_environment" "test" {
  name   = "composer-${random_string.suffix.result}"
  region = var.gcp_region

  config {
    environment_size = "ENVIRONMENT_SIZE_SMALL"
    software_config {
      image_version = var.gcp_composer_image

      airflow_config_overrides = {
        core-dags_are_paused_at_creation = "True"
        secrets-backend                  = "airflow.providers.google.cloud.secrets.secret_manager.CloudSecretManagerBackend"
        secrets-backend_kwargs = jsonencode({
          project_id         = var.gcp_project
          variables_prefix   = ""
          connections_prefix = ""
          sep                = ""
        })
      }
    }

    workloads_config {
      scheduler {
        cpu        = 0.5
        memory_gb  = 1
        storage_gb = 2
        count      = 1
      }
      web_server {
        cpu        = 0.5
        memory_gb  = 1
        storage_gb = 2
      }
      worker {
        cpu = 1
        memory_gb  = 1
        storage_gb = 2
        min_count  = 1
        max_count  = 3
      }
    }

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

  depends_on = [
    google_project_iam_member.composer_agent_v2_role,
    google_project_service.services,
    google_compute_network.default,
    google_compute_subnetwork.default,
    google_service_account.sa_composer,
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
