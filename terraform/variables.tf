variable "project_id" {
  type        = string
  description = "The GCP project ID to deploy resources to."
  default     = "pechetech-app-mg4"
}

variable "region" {
  type        = string
  description = "The GCP region to deploy resources to."
  default     = "us-central1"
}

variable "db_password" {
  type        = string
  description = "The password for the PostgreSQL administrator."
  sensitive   = true
}
