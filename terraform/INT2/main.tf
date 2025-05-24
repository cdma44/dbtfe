
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
      min_count    = 1
      max_count    = 2
      autoscaling = false
      auto_repair = true
      auto_upgrade = true
    }
  ]
}

resource "google_secret_manager_secret_version" "api_key_secret_version" {
  secret      = google_secret_manager_secret.api_key_secret.id
  secret_data = var.api_key_secret_value
}

resource "google_secret_manager_secret" "api_key_secret" {
  secret_id = "api_key_secret"
  replication {
    user_managed {
      replicas {
        location = "us-central1"
      }
      replicas {
        location = "europe-west3"
      }
    }
  }
}
