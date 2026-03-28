#
# Google Container Cluster
#

output "google_container_cluster" {
  value       = google_container_cluster.main
  description = "GCP Container Cluster"
  sensitive   = true
}

#
# Google Container Node Pool
#

output "google_container_node_pool" {
  value       = google_container_node_pool.main
  description = "GCP Container Node Pool"
  sensitive   = false
}

#
# Google Service Account
#

output "google_service_account" {
  value       = google_service_account.main
  description = "GCP Service Account"
  sensitive   = false
}
