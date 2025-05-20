variable "region" {
  description = "The GCP region to create the bucket in"
  type        = string
  default     = "europe-west3"
}

variable "bucket_name" {
  type        = string
  description = "Name of an existing GCS bucket"
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
