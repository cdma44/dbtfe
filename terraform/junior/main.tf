
provider "google" {
  project = var.project_id
  region  = var.region
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "gcs_bucket" {
  name     = "test-bucket-${random_id.bucket_suffix.hex}"
  #  name     = "junior-bucket-${var.project_id}" #with project id
  # name     = "junior-bucket-${var.project_id}-${random_id.bucket_suffix.hex}" with both random_id and project_id
  location = var.region
  force_destroy = true

  uniform_bucket_level_access = true

  labels = {
    environment = "dev"
    managed_by  = "terraform"
  }
}

variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default = "435094159146"
}

# variable "project_name" {
#   description = "The GCP project ID"
#   type        = string
#   default = "My playground"
# }

variable "region" {
  description = "The GCP region to create the bucket in"
  type        = string
  default     = "europe-west3"
}

output "bucket_name" {
  description = "The name of the created GCS bucket"
  value       = google_storage_bucket.gcs_bucket.name
}