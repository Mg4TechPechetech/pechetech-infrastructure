output "artifact_registry_repository_url" {
  value       = google_artifact_registry_repository.pechetech_repo.name
  description = "The URL of the Artifact Registry repository."
}

output "db_instance_connection_name" {
  value       = google_sql_database_instance.pechetech_db.connection_name
  description = "The connection name of the Cloud SQL database instance."
}
