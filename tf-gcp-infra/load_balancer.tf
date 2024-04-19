
resource "google_compute_managed_ssl_certificate" "ssl_certificate" {
  project       = var.project_id
  name          = var.ssl_certificate_name
  managed {
    domains = var.domains
  }
}


resource "google_compute_backend_service" "default" {
  name        = var.backend_service_name
  connection_draining_timeout_sec = 0
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10
  load_balancing_scheme = var.load_balancing_scheme
  session_affinity = var.session_affinity

  backend {
    group = google_compute_region_instance_group_manager.default.instance_group
    balancing_mode = var.balancing_mode
    capacity_scaler = 1
  }

  health_checks = [google_compute_health_check.webapp-health-check.id]

  lifecycle {
    create_before_destroy = true
  }
}


resource "google_compute_url_map" "default" {
  name            = var.url_map_name
  default_service = google_compute_backend_service.default.id

  lifecycle {
    create_before_destroy = true
  }
}


resource "google_compute_target_https_proxy" "default" {
  name             = var.proxy_name
  url_map          = google_compute_url_map.default.id
  ssl_certificates = [google_compute_managed_ssl_certificate.ssl_certificate.id]
}

resource "google_compute_global_forwarding_rule" "default" {
  name       = var.forwarding_rule_name
  target     = google_compute_target_https_proxy.default.id
  port_range = "443"
  ip_protocol = "TCP"
  load_balancing_scheme = var.load_balancing_scheme
  ip_address = google_compute_global_address.default.id
}

resource "google_compute_global_address" "default" {
  name = var.global_address_name
  ip_version = var.ip_version
}
