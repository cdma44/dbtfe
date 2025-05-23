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

variable "cluster_name" {
  type        = string
  default     = "db-pool-cluster"
  description = "Name of the GKE cluster"
}

variable "machine_type" {
  type        = string
  default     = "e2-medium"
  description = "Machine type for the node pool"
}

variable "node_count" {
  type        = number
  default     = 3
  description = "Initial node count in the default node pool"
}

# Secret value (DO NOT hardcode in production)
variable "api_key_secret_value" {
  description = "The API key stored in Secret Manager"
  type        = string
  sensitive   = true
}
