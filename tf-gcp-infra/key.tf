
resource "google_kms_key_ring" "keyring" {
  name     = "${var.keyring_name}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  location = var.config_region
}


resource "google_kms_crypto_key" "vm_key" {
  name            = var.vm_key_name
  key_ring        = google_kms_key_ring.keyring.id
  rotation_period = var.rotation_period
}

resource "google_kms_crypto_key" "cloud_sql_key" {
  name            = var.cloud_sql_key_name
  key_ring        = google_kms_key_ring.keyring.id
  rotation_period = var.rotation_period
}

resource "google_kms_crypto_key" "cloud_storage_key" {
  name            = var.cloud_storage_key_name
  key_ring        = google_kms_key_ring.keyring.id
  rotation_period = var.rotation_period
}


data "google_project" "project" {
  project_id = var.project_id
}

# 不要用member
# resource "google_kms_crypto_key_iam_member" "kms_storage" {
#   crypto_key_id = google_kms_crypto_key.cloud_storage_key.id
#   role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
#   member        = "serviceAccount:service-${data.google_project.project.number}@gs-project-accounts.iam.gserviceaccount.com"
# }


# 手动创建cloud sql的service account
# resource "google_project_service_identity" "cloudsql_service_account" {
#   project  = var.project_id
#   service  = "sqladmin.googleapis.com"
# }

resource "google_kms_crypto_key_iam_member" "kms_cloud_sql" {
  crypto_key_id = google_kms_crypto_key.cloud_sql_key.id
  role          = var.kms_role
  member        = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-cloud-sql.iam.gserviceaccount.com"
}

resource "google_kms_crypto_key_iam_binding" "kms_cloud_storage" {
  crypto_key_id = google_kms_crypto_key.cloud_storage_key.id
  role          = var.kms_role
  members        = ["serviceAccount:service-${data.google_project.project.number}@gs-project-accounts.iam.gserviceaccount.com"]
}




resource "google_kms_crypto_key_iam_member" "kms_vm_template" {
  crypto_key_id = google_kms_crypto_key.vm_key.id
  role          = var.kms_role
  member        = "serviceAccount:${google_service_account.sa.email}"
}


# resource "google_project_iam_member" "default" {
#   project = var.project_id
#   role    = var.kms_role
#   member = "serviceAccount:service-${data.google_project.project.number}@compute-system.iam.gserviceaccount.com"
# }

resource "google_project_iam_binding" "default" {
  project = var.project_id
  role    = var.kms_role
  members = [
    "serviceAccount:${google_service_account.sa.email}",
    "serviceAccount:service-${data.google_project.project.number}@compute-system.iam.gserviceaccount.com"
  ]
}
