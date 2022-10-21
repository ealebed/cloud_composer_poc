output "composer_k8s_cluster" {
  value = element(split("/", google_composer_environment.test.config[0].gke_cluster), 5)
  description = "Composer GKE cluster name"
}

output "composer_bucket" {
  value = element(split("/", google_composer_environment.test.config[0].dag_gcs_prefix), 2)
  description = "Composer bucket for DAGs, plugins and other software config files"
}

output "gke_cluster_endpoint" {
  value = data.google_container_cluster.composer_cluster.endpoint
}
