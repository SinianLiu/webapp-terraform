resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "my_bucket" {
  name     = "${var.bucket_name}-${random_id.bucket_suffix.hex}"
  location = var.config_region

  # encryption{
  #   default_kms_key_name = google_kms_crypto_key.cloud_storage_key.id
  # }
  # depends_on = [google_kms_crypto_key_iam_binding.kms_cloud_storage]
}

resource "google_storage_bucket_object" "object" {
  name   = var.object_name
  bucket = google_storage_bucket.my_bucket.name
  source = var.object_source_path
}


# service account for cloud function
resource "google_service_account" "cloud_function_sa" {
  project      = var.project_id
  account_id   = var.account_id_cloud_function
  display_name = var.display_name_cloud_function
}


resource "google_project_iam_binding" "cloud_function_iam" {
  for_each = toset(var.iam_roles_for_cloud_function)

  project = var.project_id
  role    = each.value

  members = [
    "serviceAccount:${google_service_account.cloud_function_sa.email}",
  ]
}


# pub/sub topic
resource "google_pubsub_topic" "default" {
  name = var.topic_name
  # data retention period lasts for 7 days
  message_retention_duration = var.message_retention_duration
}


# connect the cloud function to the vpc
resource "google_vpc_access_connector" "vpc_connector" {
  name          = var.vpc_connector_name
  region        = var.vpc_connector_region
  ip_cidr_range = var.vpc_connector_ip_cidr_range
  network       = google_compute_network.vpc_network.self_link
}


resource "google_cloudfunctions2_function" "default" {
  name        = var.cloud_function_name
  location    = var.cloud_function_location

  build_config {
    runtime     = var.runtime
    entry_point = var.entry_point
    environment_variables = {}
    source {
      storage_source {
        bucket = google_storage_bucket.my_bucket.name
        object = google_storage_bucket_object.object.name
      }
    }
  }

  service_config {
    max_instance_count = 3
    min_instance_count = 1
    available_memory   = var.available_memory
    timeout_seconds    = 60
    environment_variables = {
      DB_HOST = google_sql_database_instance.instance.private_ip_address
      DB_USER = google_sql_user.users.name
      DB_PASSWORD = random_password.password.result
      DB_NAME = google_sql_database.database.name
      API_KEY = var.API_KEY
    }
    ingress_settings               = var.ingress_settings
    all_traffic_on_latest_revision = true
    service_account_email          = google_service_account.cloud_function_sa.email
    vpc_connector = google_vpc_access_connector.vpc_connector.name
  }

  event_trigger {
    trigger_region = var.trigger_region
    event_type     = var.event_type
    pubsub_topic   = google_pubsub_topic.default.id
    retry_policy   = var.retry_policy
  }

}
