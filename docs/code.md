# Code

- [Code](#code)
  - [Resource: `google_container_cluster`](#resource-google_container_cluster)

## Resource: `google_container_cluster`

- lifecycle.ignore_changes: `initial_node_count` and `node_config` are required to let the default pool be created and removed when the cluster is created
- `node_config`: used for the default pool only, to avoid using default (expensive) resources that can also lead to quota constrains (i.e.: free tier)
