data "google_project" "project" {}

# https://cloud.google.com/composer/docs/composer-2/create-environments#grant-permissions
resource "google_project_iam_member" "composer_agent_v2_role" {
  project  = var.gcp_project
  role     = "roles/composer.ServiceAgentV2Ext"
  member   = "serviceAccount:service-${data.google_project.project.number}@cloudcomposer-accounts.iam.gserviceaccount.com"
}

resource "google_service_account" "sa_composer" {
  account_id   = "composer-sa"
  display_name = "composer-sa"
  description  = "Cloud Composer Service account with custom permissions"
}

resource "google_project_iam_member" "sa_composer_roles" {
  for_each = var.gcp_sa_roles

  project = var.gcp_project
  role    = each.value
  member  = "serviceAccount:${google_service_account.sa_composer.email}"
}

resource "google_service_account_key" "sa_composer" {
  service_account_id = google_service_account.sa_composer.id
}
