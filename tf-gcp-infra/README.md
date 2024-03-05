# tf-gcp-infra

## Set up Infrastructure using Terraform

1. Create a New Project in GCP Platform:
   name example: assignment3

2. Create a Terraform project folder locally:
   cd to folder
   terraform init

3. Connect Terraform to GCP project

- Install gcloud CLI
- cd to project folder
- Execute these commands:

```
gcloud auth login
gcloud auth application-default login
gcloud projects list (to check the project id)
gcloud config set project <project id>
```

4. Files created after initialization:
   main.tf
   variables.tf
   providers.tf

5. Create 'terraform.tfvars' file

Define values for variables:

```
project_id = "assignment3-414300"
vpc_name = "csye6225-vpc"
subnet_name_webapp = "webapp"
subnet_name_db = "db"
subnet_cidr_webapp = "10.0.0.0/24"
subnet_cidr_db = "10.0.1.0/24"
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
<!-- image ID here -->
image = "csye6225-1708820416"

private_ip_address_name = "private-ip-address"
purpose                 = "VPC_PEERING"
address_type            = "INTERNAL"
prefix_length           = 16
service                 = "servicenetworking.googleapis.com"
database_name           = "webapp"
database_instance_name  = "my-database-instance"
db_instance_region      = "us-central1"
database_version        = "POSTGRES_14"
tier                    = "db-f1-micro"
disk_autoresize         = true
disk_type               = "PD_SSD"
disk_size               = 10
availability_type       = "REGIONAL"
override_special        = "!%&*()-_=+[]{}<>:?"
db_user_name            = "webapp"

deletion_protection = false
ipv4_enabled = false
enable_private_path = true
password_length = 16
special = true



```

6. Each time when you update modules config in main.tf file, you need to execute:
   terraform validate
   terraform init
   terraform apply

7. Destory the vpc
   terraform destroy

<!-- terraform apply -var-file="terraform.tfvars" -->

optional commands:

gcloud config get-value project
terraform workspace list
terraform workspace show
terraform workspace select <workspace>

vpc network -> vpc network peering 手动删除 service，才能继续删除 vm
删除删不干净问题

terraform taint google_compute_instance.vm_instance
