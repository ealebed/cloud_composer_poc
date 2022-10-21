# Configuration for Kubernetes resources under the hood of Cloud Composer

# Create separate k8s namespace for DBT workload
resource "kubernetes_namespace" "dbt_namespace" {
  metadata {
    name = "dbt"
  }

  depends_on = [
    google_composer_environment.test
  ]
}

# Create k8s secret from Composer SA key [JUST TO DEMO]
resource "kubernetes_secret" "composer_keyfile" {
  metadata {
    name      = "composer-keyfile"
    namespace = kubernetes_namespace.dbt_namespace.metadata[0].name
  }
  data = {
    "keyfile.json" = base64decode(google_service_account_key.sa_composer_key.private_key)
  }

  depends_on = [
    kubernetes_namespace.dbt_namespace
  ]
}

# Create separate k8s SA in provided k8s namespace and
# annotate for using Workload Identity in GKE
# https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity
resource "kubernetes_service_account" "sa_gcr_cleaner_k8s" {
  metadata {
    name      = "gcr-cleaner-sa"
    namespace = kubernetes_namespace.dbt_namespace.metadata[0].name
    annotations = {
      "iam.gke.io/gcp-service-account" = "${google_service_account.sa_gcr_cleaner.email}"
    }
  }

  depends_on = [
    kubernetes_namespace.dbt_namespace
  ]
}
