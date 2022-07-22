resource "kubernetes_namespace" "dbt-ns" {
  metadata {
    name = "dbt"
  }

  depends_on = [
    google_composer_environment.test
  ]
}

resource "kubernetes_service_account" "dbt-sa" {
  metadata {
    name = "dbt-sa"
    namespace = kubernetes_namespace.dbt-ns.metadata[0].name
    annotations = {
      "iam.gke.io/gcp-service-account" = "${google_service_account.sa_bucket_reader.email}"
    }
  }

  depends_on = [
    kubernetes_namespace.dbt-ns
  ]
}

resource "kubernetes_persistent_volume_claim" "dbt-pvc" {
  metadata {
    name = "dbt-pvc"
    namespace = kubernetes_namespace.dbt-ns.metadata[0].name
    labels = {
      env = "dev"
      app = "dbt"
    }
  }

  wait_until_bound = false
  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }

  depends_on = [
    kubernetes_namespace.dbt-ns
  ]
}
