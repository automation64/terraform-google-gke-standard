resource "google_container_cluster" "main" {

  deletion_protection = var.google_container_cluster.deletion_protection
  location            = var.shared__location
  min_master_version  = var.google_container_cluster.min_master_version
  network             = var.google_container_cluster.network
  project             = var.shared__project_id
  subnetwork          = var.google_container_cluster.subnetwork

  datapath_provider        = local.google_container_cluster.datapath_provider
  enable_shielded_nodes    = local.google_container_cluster.enable_shielded_nodes
  enable_tpu               = local.google_container_cluster.enable_tpu
  initial_node_count       = local.google_container_cluster.initial_node_count
  name                     = local.google_container_cluster.name
  networking_mode          = local.google_container_cluster.networking_mode
  remove_default_node_pool = local.google_container_cluster.remove_default_node_pool
  resource_labels          = local.google_container_cluster.resource_labels

  workload_identity_config {
    workload_pool = "${var.shared__project_id}.svc.id.goog"
  }

  vertical_pod_autoscaling {
    enabled = var.google_container_cluster__features.vertical_pod_autoscaling
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.google_container_cluster.cluster_secondary_range_name
    services_secondary_range_name = var.google_container_cluster.services_secondary_range_name
  }

  addons_config {
    horizontal_pod_autoscaling {
      disabled = !var.google_container_cluster__features.horizontal_pod_autoscaling
    }
    http_load_balancing {
      disabled = !var.google_container_cluster__features.http_load_balancing
    }
    gce_persistent_disk_csi_driver_config {
      enabled = var.google_container_cluster__features.gce_persistent_disk_csi_driver_config
    }
    gcp_filestore_csi_driver_config {
      enabled = var.google_container_cluster__features.gcp_filestore_csi_driver_config
    }
    gcs_fuse_csi_driver_config {
      enabled = var.google_container_cluster__features.gcs_fuse_csi_driver_config
    }
    gke_backup_agent_config {
      enabled = var.google_container_cluster__features.gke_backup_agent_config
    }
    config_connector_config {
      enabled = var.google_container_cluster__features.config_connector_config
    }
  }

  control_plane_endpoints_config {
    dns_endpoint_config {
      allow_external_traffic   = local.google_container_cluster.control_plane_endpoints_config.dns_endpoint_config.allow_external_traffic
      enable_k8s_certs_via_dns = local.google_container_cluster.control_plane_endpoints_config.dns_endpoint_config.enable_k8s_certs_via_dns
    }
    ip_endpoints_config {
      enabled = local.google_container_cluster.control_plane_endpoints_config.ip_endpoints_config.enabled
    }
  }

  master_authorized_networks_config {
    private_endpoint_enforcement_enabled = local.google_container_cluster.private_endpoint_enforcement_enabled
    gcp_public_cidrs_access_enabled      = local.google_container_cluster.gcp_public_cidrs_access_enabled
  }

  release_channel {
    channel = local.google_container_cluster.release_channel
  }
  logging_config {
    enable_components = local.google_container_cluster__logging_config
  }

  private_cluster_config {
    enable_private_endpoint = var.google_container_cluster.enable_private_endpoint
    enable_private_nodes    = local.google_container_cluster.enable_private_nodes
  }

  node_config {
    disk_size_gb = local.google_container_cluster__node_config.disk_size_gb
    disk_type    = local.google_container_cluster__node_config.disk_type
    image_type   = local.google_container_cluster__node_config.image_type
    machine_type = local.google_container_cluster__node_config.machine_type
    spot         = local.google_container_cluster__node_config.spot
    metadata     = local.google_container_cluster__node_config.metadata
  }

  depends_on = [
    google_service_account.main,
    google_project_iam_member.main,
  ]

  lifecycle {
    ignore_changes = [
      initial_node_count,
      node_config
    ]
  }

  timeouts {
    create = "${var.opentofu__timeouts_minutes.create}m"
    delete = "${var.opentofu__timeouts_minutes.delete}m"
    update = "${var.opentofu__timeouts_minutes.update}m"
  }
}
