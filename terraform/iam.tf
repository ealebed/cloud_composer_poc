data "google_project" "project" {}

resource "google_service_account" "sa_composer" {
  account_id   = "composer-sa"
  display_name = "composer-sa"
  description  = "Cloud Composer Service account with custom permissions"
}

resource "google_service_account_key" "sa_composer" {
  service_account_id = google_service_account.sa_composer.id
}

resource "google_service_account" "sa_bucket_reader" {
  account_id   = "bucket-reader-sa"
  display_name = "bucket-reader-sa"
  description  = "Service Account for reading GCS bucket from Pod running in GKE"
}

# https://cloud.google.com/composer/docs/composer-2/create-environments#grant-permissions
resource "google_project_iam_member" "composer_agent_v2_role" {
  project  = var.gcp_project
  role     = "roles/composer.ServiceAgentV2Ext"
  member   = "serviceAccount:service-${data.google_project.project.number}@cloudcomposer-accounts.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "sa_composer_roles" {
  for_each = var.gcp_sa_roles

  project = var.gcp_project
  role    = each.value
  member  = "serviceAccount:${google_service_account.sa_composer.email}"
}

resource "google_project_iam_member" "sa_bucket_reader_roles" {
  project = var.gcp_project
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.sa_bucket_reader.email}"
}

resource "google_service_account_iam_binding" "dbt-sa-bind-k8s" {
  service_account_id = google_service_account.sa_bucket_reader.name
  role    = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.gcp_project}.svc.id.goog[${kubernetes_namespace.dbt-ns.metadata[0].name}/${kubernetes_service_account.dbt-sa.metadata[0].name}]",
  ]

  depends_on = [
    kubernetes_service_account.dbt-sa
  ]
}
