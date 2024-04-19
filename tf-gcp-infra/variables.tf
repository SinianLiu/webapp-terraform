variable "project_id" {
  type = string
}

variable "vpc_name" {
  type    = string
}

variable "subnet_name_webapp" {
  type    = string
}

variable "subnet_name_db" {
  type    = string
}

variable "subnet_cidr_webapp" {
  type    = string
}

variable "subnet_cidr_db" {
  type    = string
}

variable "region" {
  type    = string
}

variable "auto_create_subnetworks" {
  type    = bool
}

variable "delete_default_routes_on_create" {
  type    = bool
}

variable "routing_mode" {
  type    = string
}

variable "dest_range" {
  type    = string
}

variable "route_name" {
  type    = string
}

variable "next_hop_gateway" {
  type    = string
}


# firewall rules
variable "allow_traffic_name" {
  type    = string
}

variable "allow_traffic_protocol" {
  type    = string
}

variable "allow_traffic_ports" {
  type = list(string)
}

variable "allow_traffic_source_ranges" {
  type = list(string)
}

variable "disallow_ssh_name" {
  type    = string
}
variable "disallow_ssh_protocol" {
  type    = string
}
variable "disallow_ssh_ports" {
  type = list(string)
}

variable "disallow_ssh_source_ranges" {
  type = list(string)
}


variable "vm_instance_name" {
  type        = string
}

variable "vm_machine_type" {
  type        = string
}

variable "vm_zone" {
  type        = string
}

variable "allow_target_tags" {
  type        = list(string)
}


variable "boot_disk_type" {
  type        = string
}

variable "boot_disk_size" {
  type        = number
}

variable "image" {
  type        = string
}


# database config update
variable "private_ip_address_name" {
  type = string
}

variable "purpose" {
  type = string
}

variable "address_type" {
  type = string
}

variable "prefix_length" {
  type = number
}

variable "service" {
  type = string
}

variable "database_name" {
  type = string
}

variable "database_instance_name" {
  type = string
}

variable "db_instance_region" {
  type = string
}

variable "database_version" {
  type = string
}

variable "tier" {
  type = string
}

variable "disk_autoresize" {
  type = bool
}

variable "disk_type" {
  type = string
}

variable "disk_size" {
  type = number
}

variable "availability_type" {
  type = string
}


variable "db_user_name" {
  type = string
}


variable "deletion_protection" {
  type = bool
}

variable "ipv4_enabled" {
  type = bool
}

variable "enable_private_path" {
  type = bool
}

variable "password_length" {
  type = number
}

variable "special" {
  type = bool
}


variable "dns_name" {
  type        = string
}

variable "dns_type" {
  type        = string
}

variable "dns_ttl" {
  type        = number
}

variable "dns_managed_zone" {
  type        = string
}


variable "iam_roles" {
  type        = list(string)
}


variable "iam_roles_for_cloud_function" {
  type        = list(string)
}



variable "service_account_id" {
  type        = string
}

variable "service_account_display_name" {
  type        = string
}

variable "service_account_scopes" {
  type        = list(string)
}



variable "cloud_function_name" {
  type        = string
}

variable "cloud_function_location" {
  type        = string
}

variable "runtime" {
  type        = string
}

variable "entry_point" {
  type        = string
}

variable "bucket" {
  type        = string
}

variable "object" {
  type        = string
}

# cloud function
variable "account_id_cloud_function" {
  type = string
}

variable "display_name_cloud_function" {
  type = string
}

variable "message_retention_duration" {
  type = string
}

variable "topic_name" {
  type = string
}

variable "vpc_connector_name" {
  type = string
}

variable "vpc_connector_region" {
  type = string
}

variable "vpc_connector_ip_cidr_range" {
  type = string
}

variable "available_memory" {
  type = string
}

variable "API_KEY" {
  type = string
}

variable "trigger_region" {
  type = string
}

variable "event_type" {
  type = string
}

variable "retry_policy" {
  type = string
}

variable "ingress_settings" {
  type = string
}


# vm template and firewall
variable "instance_template_name" {
  type = string
}

variable "config_region" {
  type = string
}

variable "tags" {
  type = list(string)
}

variable "instance_description" {
  type = string
}

variable "health_check_name" {
  type = string
}

variable "request_path" {
  type = string
}

variable "group_manager_name" {
  type = string
}

variable "base_instance_name" {
  type = string
}

variable "distribution_policy_zones" {
  type = list(string)
}

variable "autoscaler_name" {
  type = string
}

variable "firewall_allow_lb_to_vms" {
  type = string
}

variable "direction" {
  type = string
}

variable "protocol" {
  type = string
}

variable "allow_lb_to_vms_port" {
  type = list(string)
}

variable "lb_source_ranges" {
  type = list(string)
}

variable "target_tags" {
  type = list(string)
}

variable "app_port" {
  type = number
}

variable "lb_port" {
  type = list(number)
}

variable "ssl_certificate_name" {
  type = string
}

variable "domains" {
  type = list(string)
}

variable "backend_service_name" {
  type = string
}

variable "load_balancing_scheme" {
  type = string
}

variable "session_affinity" {
  type = string
}

variable "balancing_mode" {
  type = string
}

variable "url_map_name" {
  type = string
}

variable "proxy_name" {
  type = string
}

variable "forwarding_rule_name" {
  type = string
}

variable "global_address_name" {
  type = string
}

variable "ip_version" {
  type = string
}

variable "firewall_allow_taffic_to_lb" {
  type = string
}


# kms keyring and key
variable "keyring_name" {
  type = string
}

variable "vm_key_name" {
  type = string
}

variable "cloud_sql_key_name" {
  type = string
}

variable "cloud_storage_key_name" {
  type = string
}

variable "rotation_period" {
  type = string
}

variable "kms_role" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "object_name" {
  type = string
}

variable "object_source_path" {
  type = string
}
