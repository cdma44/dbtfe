output "bucket_name" {
  description = "The name of the created GCS bucket is : "
  value       = google_storage_bucket.gcs_bucket.name
}