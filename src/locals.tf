locals {
  #
  # Shared
  #

  shared__labels = {
    at64_shared__automated      = "true"
    at64_shared__module_type    = "terraform"
    at64_shared__module_name    = "terraform-google-gke-standard"
    at64_shared__module_version = "1-0-0"
  }

  shared__prefix = {
    google_container_cluster   = coalesce(var.shared__prefix.google_container_cluster, module.lib_catalog.pgg.gke_cluster)
    google_container_node_pool = coalesce(var.shared__prefix.google_container_node_pool, module.lib_catalog.pgg.gke_node_pool)
    google_service_account     = coalesce(var.shared__prefix.google_service_account, module.lib_catalog.pgg.service_account)
  }

  shared__name_instance = "${var.shared__name}-${format("%04d", random_integer.main.result)}"

  #
  # Google Container Cluster
  #

  google_container_cluster = {
    name = "${local.shared__prefix.google_container_cluster}-${var.shared__name}"

    datapath_provider                    = "ADVANCED_DATAPATH"
    enable_private_nodes                 = true
    enable_shielded_nodes                = true
    enable_tpu                           = false
    gcp_public_cidrs_access_enabled      = false
    initial_node_count                   = 1
    networking_mode                      = "VPC_NATIVE"
    private_endpoint_enforcement_enabled = true
    release_channel                      = "UNSPECIFIED"
    remove_default_node_pool             = true

    resource_labels = merge(
      local.shared__labels,
      var.shared__labels
    )
    control_plane_endpoints_config = {
      dns_endpoint_config = {
        allow_external_traffic   = !var.google_container_cluster.enable_private_endpoint
        enable_k8s_certs_via_dns = false
      }
      ip_endpoints_config = {
        enabled = false
      }
    }
  }

  google_container_cluster__node_config = {
    disk_size_gb = 12
    disk_type    = "pd-standard"
    image_type   = "COS_CONTAINERD"
    machine_type = "e2-small"
    spot         = true
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    metadata = {
      "disable-legacy-endpoints" = true
    }
  }

  google_container_cluster__logging_config = concat(
    var.google_container_cluster__logging_config,
    [
      "SYSTEM_COMPONENTS"
    ]
  )

  #
  # Google Container Node Pool
  #
  google_container_node_pool = {
    name                 = "${local.shared__prefix.google_container_node_pool}-${var.shared__name}"
    enable_private_nodes = true
    create_pod_range     = false
    metadata = {
      "disable-legacy-endpoints" = true
    }
    management = {
      auto_repair  = true
      auto_upgrade = false
    }
    upgrade_settings = {
      strategy = "SURGE"
    }
  }

  google_container_node_pool__node_config = {
    workload_metadata_config = {
      mode = "GKE_METADATA"
    }
    shielded_instance_config = {
      enable_integrity_monitoring = true
      enable_secure_boot          = true
    }
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    metadata = {
      "disable-legacy-endpoints" = true
    }
  }

  #
  # Google Service Account
  #

  google_service_account = {
    account_id                   = "${local.shared__prefix.google_service_account}-${local.shared__name_instance}"
    description                  = "Dedicated Service Account for Google Container Cluster GKE"
    disabled                     = false
    create_ignore_already_exists = false
  }

  google_project_iam_member__roles = toset([
    "roles/container.defaultNodeServiceAccount",
    "roles/artifactregistry.reader",
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/storage.objectViewer"
  ])
}
