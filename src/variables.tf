#
# Shared
#

variable "shared__name" {
  description = "Name seed to be used for naming generated module objects"
  sensitive   = false
  nullable    = false
  type        = string
}

variable "shared__location" {
  description = "GCP location where resources will be deployed to"
  sensitive   = false
  nullable    = false
  type        = string
}

variable "shared__prefix" {
  description = "Prefix definition for naming generated module objects"
  sensitive   = false
  nullable    = true
  type = object({
    google_container_cluster   = optional(string)
    google_container_node_pool = optional(string)
    google_service_account     = optional(string)
  })
  default = {}
}

variable "shared__labels" {
  description = "Common labels to be applied to all resources"
  sensitive   = false
  nullable    = true
  type        = map(string)
  default     = {}
}

variable "shared__project_id" {
  description = "GCP Project ID where resources will be deployed to"
  sensitive   = false
  nullable    = false
  type        = string
}

variable "opentofu__timeouts_minutes" {
  description = "Opentofu Timeouts"
  sensitive   = false
  nullable    = true
  type = object({
    create = optional(number, 30)
    delete = optional(number, 20)
    update = optional(number, 20)
  })
  default = {}
}

#
# Google Container Cluster
#

variable "google_container_cluster" {
  description = "GCP Container Cluster attributes"
  sensitive   = false
  nullable    = false
  type = object({
    cluster_secondary_range_name  = string
    services_secondary_range_name = string
    network                       = string
    subnetwork                    = string
    enable_private_endpoint       = optional(bool, false)
    min_master_version            = optional(string)
    deletion_protection           = optional(bool, false)
  })
}

variable "google_container_cluster__logging_config" {
  description = "GCP Container Cluster Logging Config"
  sensitive   = false
  nullable    = true
  type        = list(string)
  default = [
    "WORKLOADS"
  ]
}

variable "google_container_cluster__features" {
  description = "GCP Container Cluster Features"
  sensitive   = false
  nullable    = true
  type = object({
    config_connector_config               = optional(bool, false)
    gce_persistent_disk_csi_driver_config = optional(bool, false)
    gcp_filestore_csi_driver_config       = optional(bool, false)
    gcs_fuse_csi_driver_config            = optional(bool, false)
    gke_backup_agent_config               = optional(bool, false)
    horizontal_pod_autoscaling            = optional(bool, true)
    http_load_balancing                   = optional(bool, false)
    vertical_pod_autoscaling              = optional(bool, true)
  })
  default = {}
}

#
# Google Container Node Pool
#

variable "google_container_node_pool" {
  description = "GCP Container Node Pool attributes"
  sensitive   = false
  nullable    = true
  type = object({
    version = optional(string)
    upgrade_settings = optional(object({
      max_surge       = optional(number, 1)
      max_unavailable = optional(number, 0)
    }), {})
  })
  default = {}
}

variable "google_container_node_pool__node_config" {
  description = "GCP Container Node Pool Node attributes"
  sensitive   = false
  nullable    = true
  type = object({
    machine_type = optional(string)
    disk_size_gb = optional(number)
    image_type   = optional(string)
    disk_type    = optional(string)
    spot         = optional(bool)
  })
  default = {
    machine_type = "e2-small"
    disk_size_gb = 12
    image_type   = "COS_CONTAINERD"
    disk_type    = "pd-standard"
    spot         = true
  }
}

variable "google_container_node_pool__autoscaling" {
  description = "GCP Container Node Pool Autoscaling attributes"
  sensitive   = false
  nullable    = true
  type = object({
    min_node_count  = optional(number)
    max_node_count  = optional(number)
    location_policy = optional(string)
  })
  default = {
    min_node_count  = 0
    max_node_count  = 1
    location_policy = "BALANCED"
  }
}
