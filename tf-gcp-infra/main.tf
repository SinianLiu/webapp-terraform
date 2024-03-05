# VPC Config
resource "google_compute_network" "vpc_network" {
  project                  = var.project_id
  name                     = var.vpc_name
  auto_create_subnetworks  = var.auto_create_subnetworks
  delete_default_routes_on_create = var.delete_default_routes_on_create
  routing_mode             = var.routing_mode
}

resource "google_compute_subnetwork" "webapp_subnet" {
  name          = var.subnet_name_webapp
  ip_cidr_range = var.subnet_cidr_webapp
  network       = google_compute_network.vpc_network.self_link
  region        = var.region
}

resource "google_compute_subnetwork" "db_subnet" {
  name          = var.subnet_name_db
  ip_cidr_range = var.subnet_cidr_db
  network       = google_compute_network.vpc_network.self_link
  region        = var.region
}

resource "google_compute_route" "default_route" {
  name        = var.route_name
  dest_range  = var.dest_range
  network     = google_compute_network.vpc_network.self_link
  next_hop_gateway = var.next_hop_gateway
}


# Firewall rules Config
# Allow traffic to port 8080
resource "google_compute_firewall" "allow_traffic_to_webapp" {
  name    = var.allow_traffic_name
  network = google_compute_network.vpc_network.name

  allow {
    protocol = var.allow_traffic_protocol
    ports    = var.allow_traffic_ports
  }

  source_ranges = var.allow_traffic_source_ranges
}


# Disallow traffic to SSH port
resource "google_compute_firewall" "disallow_traffic_to_ssh_port" {
  name    = var.disallow_ssh_name
  network = google_compute_network.vpc_network.name

  allow {
    protocol = var.disallow_ssh_protocol
    ports    = var.disallow_ssh_ports
  }

  source_ranges = var.disallow_ssh_source_ranges
}


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



# CloudSQL Database Config
resource "google_sql_database" "database" {
  name     = var.database_name
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_database_instance" "instance" {

  name             = var.database_instance_name
  region           = var.db_instance_region
  database_version = var.database_version
  deletion_protection  = var.deletion_protection

  depends_on = [google_service_networking_connection.private_vpc_connection]
  settings {
    tier = var.tier

    ip_configuration {
      # not be accessible from the internet.
      ipv4_enabled    = var.ipv4_enabled
      # can only be accessed by the compute engine instance
      private_network = google_compute_network.vpc_network.id
      enable_private_path_for_google_cloud_services = var.enable_private_path
    }

    disk_autoresize = var.disk_autoresize
    disk_type       = var.disk_type
    disk_size       = var.disk_size

    availability_type   = var.availability_type
  }

}


resource "random_password" "password" {
  length           = var.password_length
  special          = var.special
  override_special = var.override_special
}


resource "google_sql_user" "users" {
  name     = var.db_user_name
  instance = google_sql_database_instance.instance.name
  password = random_password.password.result
}


# vritual machine config
resource "google_compute_instance" "vm_instance" {
  name         = var.vm_instance_name
  machine_type = var.vm_machine_type
  zone         = var.vm_zone
  tags         = var.allow_target_tags

  boot_disk {
    initialize_params {
      image = var.image
      type  = var.boot_disk_type
      size  = var.boot_disk_size
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.webapp_subnet.self_link

    access_config {
      // setup public IP
      // Ephemeral IP
    }
  }


  metadata = {
    startup-script = <<-EOT
    #!/bin/bash
    set -e

    sudo echo "DB_HOST=${google_sql_database_instance.instance.private_ip_address}" >> /opt/myapp/.env
    sudo echo "DB_PASSWORD=${random_password.password.result}" >> /opt/myapp/.env
    sudo echo "DB_USERNAME=${google_sql_user.users.name}" >> /opt/myapp/.env
    sudo echo "DB_NAME=${google_sql_database.database.name}" >> /opt/myapp/.env

    sudo systemctl restart webapp
    EOT
  }
}
