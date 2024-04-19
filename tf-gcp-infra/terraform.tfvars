project_id = "dev-project-415104"
vpc_name = "csye6225-vpc-demo"
subnet_name_webapp = "webapp"
subnet_name_db = "db"
subnet_cidr_webapp = "192.168.4.0/24"
subnet_cidr_db = "192.168.5.0/24"
region = "us-west1"
auto_create_subnetworks = false
delete_default_routes_on_create = true
routing_mode = "REGIONAL"
dest_range = "0.0.0.0/0"
route_name = "default-internet-gateway"
next_hop_gateway = "default-internet-gateway"


allow_traffic_name = "allow-traffic-from-webapp"
allow_traffic_protocol = "tcp"
allow_traffic_ports = ["8080"]
allow_traffic_source_ranges = ["0.0.0.0/0"]

disallow_ssh_name = "disallow-trafic-to-ssh-port"
disallow_ssh_protocol = "tcp"
disallow_ssh_ports = ["22"]
disallow_ssh_source_ranges = ["0.0.0.0/0"]

vm_instance_name = "csye6225-vm"
vm_machine_type = "e2-medium"
vm_zone = "us-west1-a"
allow_target_tags = ["allow-traffic-from-webapp", "disallow-trafic-to-ssh-port"]
boot_disk_type = "pd-balanced"
boot_disk_size = 100
image = "csye6225-1712345537"


# db
private_ip_address_name = "private-ip-address"
purpose                 = "VPC_PEERING"
address_type            = "INTERNAL"
prefix_length           = 16
service                 = "servicenetworking.googleapis.com"
database_name           = "webapp"
database_instance_name  = "my-database-instance-new"
db_instance_region      = "us-west1"
database_version        = "POSTGRES_14"
tier                    = "db-f1-micro"
disk_autoresize         = true
disk_type               = "PD_SSD"
disk_size               = 10
availability_type       = "REGIONAL"
db_user_name            = "webapp"
deletion_protection = false
ipv4_enabled = false
enable_private_path = true
password_length = 10
special = false

# dns
dns_name         = "sinianliu.me."
dns_type         = "A"
dns_ttl          = 300
dns_managed_zone = "csye6225-dns"

# service account and iam roles
service_account_id            = "csye6225-service-account-new"
service_account_display_name  = "Service Account for VM Instance"
service_account_scopes = ["cloud-platform"]
iam_roles = ["roles/logging.admin", "roles/monitoring.metricWriter","roles/viewer","roles/pubsub.editor","roles/pubsub.publisher","roles/cloudsql.client"]
iam_roles_for_cloud_function = ["roles/monitoring.metricWriter","roles/viewer","roles/pubsub.editor","roles/run.invoker"]


# cloud function
cloud_function_name        = "serverless-function"
cloud_function_location    = "us-west1"
runtime     = "nodejs20"
entry_point = "sendEmail"
bucket      = "csye6225-bucket-sinian-new"
object      = "serverless.zip"

account_id_cloud_function = "csye6225-sa-for-cloud-function"
display_name_cloud_function = "Service Account for Cloud Function"
message_retention_duration = "604800s"
topic_name = "verify_email"
vpc_connector_name = "vpc-connector"
vpc_connector_region = "us-west1"
vpc_connector_ip_cidr_range = "10.10.0.0/28"

available_memory = "256M"
API_KEY = "f65a0b441829301d3ec7a2df685a71b8-f68a26c9-7ef6afd6"
trigger_region = "us-west1"
event_type = "google.cloud.pubsub.topic.v1.messagePublished"
retry_policy = "RETRY_POLICY_RETRY"
ingress_settings = "ALLOW_INTERNAL_ONLY"



# vm_template and firewall
allow_lb_to_vms_port=["8080"]
autoscaler_name="csye6225-autoscaler"
app_port=8080
backend_service_name="my-backend-service"
balancing_mode = "UTILIZATION"
base_instance_name = "csye6225-vm"
config_region="us-west1"
direction = "INGRESS"
domains=["sinianliu.me"]
distribution_policy_zones = ["us-west1-a", "us-west1-b", "us-west1-c"]

firewall_allow_taffic_to_lb="allow-traffic-to-load-balancer"
firewall_allow_lb_to_vms="allow-lb-to-vms"
forwarding_rule_name= "my-forwarding-rule"
global_address_name= "my-global-address"
group_manager_name="csye6225-igm"
health_check_name="webapp-health-check"
instance_description= "Instance for CSYE6225"
instance_template_name="csye6225-vm-template"
ip_version = "IPV4"
lb_source_ranges=["130.211.0.0/22", "35.191.0.0/16"]
lb_port=["443"]
load_balancing_scheme = "EXTERNAL"

protocol = "tcp"
proxy_name="my-https-proxy"
request_path       = "/healthz"
session_affinity = "NONE"
ssl_certificate_name="csye6255-ssl-certificate"
tags=["allow-lb"]
target_tags = ["allow-lb"]
url_map_name="my-url-map"


# kms keys
keyring_name = "csye6225-keyring"
vm_key_name = "vm-key"
cloud_sql_key_name = "cloud-sql-key"
cloud_storage_key_name = "cloud-storage-key"
rotation_period = "2592000s"
kms_role = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
bucket_name = "csye6225-bucket-sinian"
object_name = "serverless.zip"
object_source_path = "/Users/sinianliu/Desktop/serverless.zip"
