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

Define values for variables

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

(optional)manully delete:
vpc network -> vpc network peering 手动删除 service，才能继续删除 vm

terraform taint google_compute_instance.vm_instance

dnf install postgresql...
psql -h host -U webapp -d webapp
SELECT \* FROM "Users";

<!-- 为什么需要Service account for pub/sub -->
