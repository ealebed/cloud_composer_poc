resource "google_project_service" "services" {
  for_each           = var.gcp_apis

  service            = each.value
  disable_on_destroy = false
}
