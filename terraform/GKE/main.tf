
module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 30.0"

  project_id = var.project_id
  name       = var.cluster_name
  region     = var.region

  network    = "default"
  subnetwork = "default"

  ip_range_pods     = ""
  ip_range_services = ""

  remove_default_node_pool = true
  initial_node_count       = 1

  node_pools = [
    {
      name       = "db-test-pool"
      machine_type = var.machine_type
      node_count = var.node_count
      autoscaling = false
      auto_repair = true
      auto_upgrade = true
    }
  ]
}