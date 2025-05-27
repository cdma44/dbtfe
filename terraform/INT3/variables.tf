
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

variable "location" {
  type        = string
  default     = "us-central1"
  description = "Region for the GKE cluster"
}