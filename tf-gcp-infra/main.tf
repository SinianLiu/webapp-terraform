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
# only allow traffic from the load balancer now

# resource "google_compute_firewall" "allow_traffic_to_webapp" {
#   name    = var.allow_traffic_name
#   network = google_compute_network.vpc_network.name

#   allow {
#     protocol = var.allow_traffic_protocol
#     ports    = var.allow_traffic_ports
#   }

#   source_ranges = var.allow_traffic_source_ranges
# }


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



# create service account
resource "google_service_account" "sa" {
  project      = var.project_id
  account_id   = var.service_account_id
  display_name = var.service_account_display_name
}


# Bind 2 roles to the service account
resource "google_project_iam_binding" "logging_admin" {
  for_each = toset(var.iam_roles)

  project = var.project_id
  role    = each.value

  members = [
    "serviceAccount:${google_service_account.sa.email}",
  ]
}



# resource "google_compute_instance" "vm_instance" {
#   name         = var.vm_instance_name
#   machine_type = var.vm_machine_type
#   zone         = var.vm_zone
#   tags         = var.allow_target_tags

#   boot_disk {
#     initialize_params {
#       image = var.image
#       type  = var.boot_disk_type
#       size  = var.boot_disk_size
#     }
#   }

#   network_interface {
#     network = google_compute_network.vpc_network.name
#     subnetwork = google_compute_subnetwork.webapp_subnet.self_link

#     access_config {
#       // setup public IP
#       // Ephemeral IP
#     }
#   }

# # attach service account to the vm
#   service_account {
#     email  = google_service_account.sa.email
#     scopes = var.service_account_scopes
#   }


#   metadata = {
#     startup-script = <<-EOT
#     #!/bin/bash
#     set -e

#     sudo echo "DB_HOST=${google_sql_database_instance.instance.private_ip_address}" >> /opt/myapp/.env
#     sudo echo "DB_PASSWORD=${random_password.password.result}" >> /opt/myapp/.env
#     sudo echo "DB_USERNAME=${google_sql_user.users.name}" >> /opt/myapp/.env
#     sudo echo "DB_NAME=${google_sql_database.database.name}" >> /opt/myapp/.env

#     sudo systemctl restart webapp
#     EOT
#   }
# }



# Cloud DNS zone
# resource "google_dns_record_set" "a_record" {
#   name         = var.dns_name
#   type         = var.dns_type
#   ttl          = var.dns_ttl
#   managed_zone = var.dns_managed_zone
#   rrdatas = [google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip]

#   depends_on = [
#     google_compute_instance.vm_instance
#   ]
# }



# Update the DNS record to point the domain to load balancer IP address.
resource "google_dns_record_set" "a_record" {
  name         = var.dns_name
  type         = "A"
  ttl          = var.dns_ttl
  managed_zone = var.dns_managed_zone
  rrdatas      = [google_compute_global_forwarding_rule.default.ip_address]

  depends_on = [
    google_compute_global_forwarding_rule.default
  ]
}
