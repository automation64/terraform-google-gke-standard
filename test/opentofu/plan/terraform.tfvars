shared__location = "us-central1"
shared__name     = "test"

google_container_node_pool__node_config = {
  machine_type = "e2-small"
  disk_size_gb = 12
  image_type   = "COS_CONTAINERD"
  disk_type    = "pd-standard"
  spot         = true
}

google_container_node_pool__autoscaling = {
  min_node_count  = 1
  max_node_count  = 1
  location_policy = "BALANCED"
}

# Use TF_VAR to set test time values
# google_container_cluster = {
#   deletion_protection           = true
#   cluster_secondary_range_name  = "TBD"
#   services_secondary_range_name = "TBD"
#   network                       = "TBD"
#   subnetwork                    = "TBD"
# }
