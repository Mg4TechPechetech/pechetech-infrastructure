provider "google" {
  project = var.project_id
  region  = var.region
}

# 1. Artifact Registry Repository
resource "google_artifact_registry_repository" "pechetech_repo" {
  location      = var.region
  repository_id = "pechetech-repo"
  description   = "Docker repository for PecheTech Microservices"
  format        = "DOCKER"
}

# 2. Cloud SQL PostgreSQL Database
resource "google_sql_database_instance" "pechetech_db" {
  name             = "pechetech-db"
  database_version = "POSTGRES_15"
  region           = var.region

  settings {
    tier = "db-f1-micro" # Petit profil économique pour dev/staging

    database_flags {
      name  = "max_connections"
      value = "100"
    }
  }

  deletion_protection = false
}

resource "google_sql_database" "database" {
  name     = "pechetech"
  instance = google_sql_database_instance.pechetech_db.name
}

resource "google_sql_user" "users" {
  name     = "postgres"
  instance = google_sql_database_instance.pechetech_db.name
  password = var.db_password
}

# 3. Secret Manager to store DB password
resource "google_secret_manager_secret" "db_password" {
  secret_id = "db-password"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_password_version" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = var.db_password
}
