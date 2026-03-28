resource "google_container_node_pool" "main" {
  version = var.google_container_node_pool.version

  name = local.google_container_node_pool.name

  cluster  = google_container_cluster.main.id
  location = google_container_cluster.main.location
  project  = google_container_cluster.main.project

  network_config {
    subnetwork           = var.google_container_cluster.subnetwork
    pod_range            = var.google_container_cluster.cluster_secondary_range_name
    enable_private_nodes = local.google_container_node_pool.enable_private_nodes
    create_pod_range     = local.google_container_node_pool.create_pod_range
  }

  autoscaling {
    min_node_count  = var.google_container_node_pool__autoscaling.min_node_count
    max_node_count  = var.google_container_node_pool__autoscaling.max_node_count
    location_policy = var.google_container_node_pool__autoscaling.location_policy
  }

  management {
    auto_repair  = local.google_container_node_pool.management.auto_repair
    auto_upgrade = local.google_container_node_pool.management.auto_upgrade
  }

  upgrade_settings {
    max_surge       = var.google_container_node_pool.upgrade_settings.max_surge
    max_unavailable = var.google_container_node_pool.upgrade_settings.max_unavailable
    strategy        = local.google_container_node_pool.upgrade_settings.strategy
  }

  node_config {
    disk_size_gb = var.google_container_node_pool__node_config.disk_size_gb
    disk_type    = var.google_container_node_pool__node_config.disk_type
    image_type   = var.google_container_node_pool__node_config.image_type
    machine_type = var.google_container_node_pool__node_config.machine_type
    spot         = var.google_container_node_pool__node_config.spot

    service_account = google_service_account.main.email
    metadata        = local.google_container_node_pool__node_config.metadata
    oauth_scopes    = local.google_container_node_pool__node_config.oauth_scopes

    shielded_instance_config {
      enable_integrity_monitoring = local.google_container_node_pool__node_config.shielded_instance_config.enable_integrity_monitoring
      enable_secure_boot          = local.google_container_node_pool__node_config.shielded_instance_config.enable_secure_boot
    }

    workload_metadata_config {
      mode = local.google_container_node_pool__node_config.workload_metadata_config.mode
    }

    gcfs_config {
      enabled = true
    }

    gvnic {
      enabled = true
    }

  }

  timeouts {
    create = "${var.opentofu__timeouts_minutes.create}m"
    delete = "${var.opentofu__timeouts_minutes.delete}m"
    update = "${var.opentofu__timeouts_minutes.update}m"
  }
}
