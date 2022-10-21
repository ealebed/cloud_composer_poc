# Configuration for a Google Cloud service accounts and IAM policy for a project

resource "google_service_account" "sa_composer" {
  account_id   = "composer-sa"
  display_name = "composer-sa"
  description  = "Cloud Composer Service account with custom permissions"
}

# Create Composer SA key [JUST TO DEMO]
resource "google_service_account_key" "sa_composer_key" {
  service_account_id = google_service_account.sa_composer.id
}

resource "google_service_account" "sa_gcr_cleaner" {
  account_id   = "gcr-cleaner-sa"
  display_name = "gcr-cleaner-sa"
  description  = "Service Account for cleaning old docker image versions in Artifact Registry"
}

# Grant required permissions to Cloud Composer service account
# https://cloud.google.com/composer/docs/composer-2/create-environments#grant-permissions
resource "google_project_iam_member" "composer_agent_v2_role" {
  project  = var.gcp_project
  role     = "roles/composer.ServiceAgentV2Ext"
  member   = "serviceAccount:service-${data.google_project.project.number}@cloudcomposer-accounts.iam.gserviceaccount.com"
}

# Updates the IAM policy to grant a roles to a Cloud Composer service account
resource "google_project_iam_member" "sa_composer_roles" {
  for_each = var.gcp_sa_composer_roles

  project = var.gcp_project
  role    = each.value
  member  = "serviceAccount:${google_service_account.sa_composer.email}"
}

# Updates the IAM policy to grant a roles to a GCR-cleaner service account
resource "google_project_iam_member" "sa_gcr_cleaner_roles" {
  for_each = var.gcp_sa_gcr_cleaner_roles

  project = var.gcp_project
  role    = each.value
  member  = "serviceAccount:${google_service_account.sa_gcr_cleaner.email}"
}

# Updates the IAM policy to grant a role to Kubernetes Service Account used for cleaning GCR 
# Other roles within the IAM policy for the service account are preserved
# Related docs:
# https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity
resource "google_service_account_iam_binding" "gcr_cleaner_sa_bind_k8s" {
  service_account_id = google_service_account.sa_gcr_cleaner.name
  role    = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.gcp_project}.svc.id.goog[${kubernetes_namespace.dbt_namespace.metadata[0].name}/${kubernetes_service_account.sa_gcr_cleaner_k8s.metadata[0].name}]",
  ]

  depends_on = [
    kubernetes_service_account.sa_gcr_cleaner_k8s
  ]
}
