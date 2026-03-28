# Architecture

- [Architecture](#architecture)
  - [Worker Nodes](#worker-nodes)
    - [Node Pools](#node-pools)
    - [Node Image](#node-image)
    - [Node Security](#node-security)
  - [Authentication](#authentication)
    - [Credentials](#credentials)

## Worker Nodes

### Node Pools

- Use separate node pool definitions (`google_container_node_pool`) instead of cluster level
- Do not use default node pool. Must be removed once the cluster is created (cluster can not be created empty)
- Use minimum setup for the default node pool

Reference: https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/using_gke_with_terraform#node-pool-management

- Automatic node pool upgrade is disabled

Reference: https://docs.cloud.google.com/kubernetes-engine/docs/how-to/node-auto-upgrades

### Node Image

- Prefer using Container-Optimized OS (COS) `COS_CONTAINERD`

Reference: https://docs.cloud.google.com/kubernetes-engine/docs/concepts/node-images

- Use container image streaming

Reference: https://cloud.google.com/blog/products/containers-kubernetes/introducing-container-image-streaming-in-gke

- Use Google Virtual NIC (GVNIC)

Reference: https://docs.cloud.google.com/compute/docs/networking/using-gvnic

### Node Security

- Use Shielded GKE Nodes

Reference: https://docs.cloud.google.com/kubernetes-engine/docs/how-to/shielded-gke-nodes

## Authentication

### Credentials

- Use Workload Identity

Reference: https://docs.cloud.google.com/kubernetes-engine/docs/concepts/workload-identity
