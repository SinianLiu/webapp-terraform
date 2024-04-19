
resource "random_id" "suffix" {
  byte_length = 4
}

# 不加随机后缀的话，每次apply会报错，因为instance_template的name不能重复
resource "google_compute_region_instance_template" "default" {
  name = "${var.instance_template_name}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  region      = var.config_region
  tags = var.tags

  instance_description = var.instance_description
  machine_type         = var.vm_machine_type

  disk {
    source_image      = var.image
    auto_delete       = true
    boot              = true

# KMS key Configuration
    disk_encryption_key {
      kms_key_self_link = google_kms_crypto_key.vm_key.id
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.webapp_subnet.self_link

    access_config {}
  }

  service_account {
    email  = google_service_account.sa.email
    scopes = var.service_account_scopes
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

# health check
resource "google_compute_health_check" "webapp-health-check" {
  name        = var.health_check_name

  timeout_sec         = 10
  check_interval_sec  = 10
  healthy_threshold   = 2
  unhealthy_threshold = 5

  http_health_check {
    port               = var.app_port
    request_path       = var.request_path
  }

  log_config {
    enable = true
  }
}


# group manager
resource "google_compute_region_instance_group_manager" "default" {
  name               = var.group_manager_name
  region             = var.config_region
  base_instance_name = var.base_instance_name
  distribution_policy_zones = var.distribution_policy_zones

  named_port {
    name = "http"
    port = var.app_port
  }

  version {
    instance_template = google_compute_region_instance_template.default.id
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.webapp-health-check.id
    initial_delay_sec = 300
  }

  update_policy {
    type                  = "PROACTIVE"
    minimal_action        = "REPLACE"
    max_surge_fixed       = 3
    max_unavailable_fixed = 0
    instance_redistribution_type = "PROACTIVE"
  }

  lifecycle {
    prevent_destroy = false
  }
}


# autoscaler
resource "google_compute_region_autoscaler" "default" {
  name   = var.autoscaler_name
  region = var.config_region
  target = google_compute_region_instance_group_manager.default.id

  autoscaling_policy {
    max_replicas    = 4
    min_replicas    = 2
    cooldown_period = 60

    cpu_utilization {
      target = 0.05
    }
  }
}


# Update firewall ingress rules
# allow traffic from the load balancer to the instances
resource "google_compute_firewall" "allow_lb_to_vms" {
  name    = var.firewall_allow_lb_to_vms
  network = google_compute_network.vpc_network.id
  direction = var.direction

  allow {
    protocol = var.protocol // "tcp"
    ports    = var.allow_lb_to_vms_port // ["8080"]
  }

  source_ranges = var.lb_source_ranges // load balancer’s ip range
  target_tags = var.target_tags // ["allow-lb"], attach to the instance
}


# allow traffic from the outside to the load balancer
resource "google_compute_firewall" "allow_taffic_to_lb" {
  name          = var.firewall_allow_taffic_to_lb
  direction     = var.direction
  network       = google_compute_network.vpc_network.name
  priority      = 1000
  source_ranges = var.allow_traffic_source_ranges

  allow {
    ports    = var.lb_port
    protocol = var.protocol
  }
}
