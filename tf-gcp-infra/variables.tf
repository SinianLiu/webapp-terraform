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


variable "override_special" {
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
