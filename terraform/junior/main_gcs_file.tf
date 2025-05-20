# provider "google" {
#   project = var.project_id
#   region  = var.region
# }

resource "google_storage_bucket_object" "settings_file" {
  name   = "config/settings.txt"
  bucket = var.bucket_name
  content = "Hello from Terraform!"
}

# variable "project_id" {
#   type        = string
#   default = "435094159146"
# }

# variable "region" {
#   description = "The GCP region to create the bucket in"
#   type        = string
#   default     = "europe-west3"
# }

variable "bucket_name" {
  type        = string
  description = "Name of an existing GCS bucket"
}