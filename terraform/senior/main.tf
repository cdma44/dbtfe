provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "senior_gcs_bucket" {
  name                        = "senior-bucket"
  # name     = "junior-bucket-${var.project_id}"   # with project id
  # name     = "junior-bucket-${var.project_id}-${random_id.bucket_suffix.hex}"  #with both random_id and project_id
  location                    = var.region
  project                     = var.project_id
  force_destroy               = true
  uniform_bucket_level_access = true
  labels = {
    environment = "senior"
    managed_by  = "terraform"
  }
}

variable "project_id" {
  type    = string
  default = "project-db-460412"
}

variable "project_name" {
  description = "The GCP project ID"
  type        = string
  default     = "project-db"
}

variable "region" {
  description = "The GCP region to create the bucket in"
  type        = string
  default     = "europe-west3"
}