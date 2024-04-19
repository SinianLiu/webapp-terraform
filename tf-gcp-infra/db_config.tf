
# CloudSQL Database Config
resource "google_sql_user" "users" {
  name     = var.db_user_name
  instance = google_sql_database_instance.instance.name
  password = random_password.password.result
}

resource "random_password" "password" {
  length           = var.password_length
  special          = var.special
}

resource "google_sql_database" "database" {
  name     = var.database_name
  instance = google_sql_database_instance.instance.name
}

# connect db to the vpc
resource "google_compute_global_address" "private_ip_address" {

  name          = var.private_ip_address_name
  purpose       = var.purpose
  address_type  = var.address_type
  prefix_length = var.prefix_length

  network       = google_compute_network.vpc_network.id
}

resource "google_service_networking_connection" "private_vpc_connection" {

  network                 = google_compute_network.vpc_network.id
  service                 = var.service
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}



# CloudSQL Database Instance
resource "google_sql_database_instance" "instance" {

  name             = var.database_instance_name
  region           = var.db_instance_region
  database_version = var.database_version
  deletion_protection  = var.deletion_protection

  depends_on = [google_service_networking_connection.private_vpc_connection]
  settings {
    tier = var.tier
    disk_autoresize = var.disk_autoresize
    disk_type       = var.disk_type
    disk_size       = var.disk_size
    availability_type   = var.availability_type
    ip_configuration {
      # not be accessible from the internet.
      ipv4_enabled    = var.ipv4_enabled
      # can only be accessed by the compute engine instance
      private_network = google_compute_network.vpc_network.id
      enable_private_path_for_google_cloud_services = var.enable_private_path
    }
  }

  encryption_key_name = google_kms_crypto_key.cloud_sql_key.id
}
