#resource to generate random unique id
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# resource to create gcs bucket with name and random unique id
resource "google_storage_bucket" "db_junior_gcs_bucket" {
  name                        = "test-bucket-${random_id.bucket_suffix.hex}"
  # name     = "junior-bucket-${var.project_id}"   # with project id
  # name     = "junior-bucket-${var.project_id}-${random_id.bucket_suffix.hex}"  #with both random_id and project_id
  location                    = var.region
  force_destroy               = true
  uniform_bucket_level_access = true
  labels = {
    environment = "dev"
    managed_by  = "terraform"
  }
}

# This will create an object with name config/settings.txt
resource "google_storage_bucket_object" "object_settings_file" {
  name    = "config/settings.txt"
  bucket  = var.bucket_name
  content = "Hello from Terraform!"  #this is the content inside the file
}