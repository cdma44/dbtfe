provider "google" {
  project = var.project_id
  region  = var.region
}

variable "project_id" {
  type        = string
  description = "GCP project ID"
  default = "project-db-460412"
}

variable "region" {
  type        = string
  default     = "europe-west3"
  description = "Region for the GKE cluster"
}

variable "secret_value" {
  description = "The secret value to store in Secret Manager"
  type        = string
  sensitive   = true
}
resource "google_secret_manager_secret_version" "my_secret_version" {
  secret      = google_secret_manager_secret.my_secret.id
  secret_data = var.secret_value
}

resource "google_secret_manager_secret" "my_secret" {
  secret_id = "my-secret"
  replication {
    user_managed {
      replicas {
        location = "us-central1"
      }
      replicas {
        location = "us-east1"
      }
    }
  }
}



