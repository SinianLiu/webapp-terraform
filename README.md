# Network Structure & Cloud Computing Project
This is an ongoing project which has been finished by 60% \n
**Inside each folder, there is README.md file containing way more detailed configurations and steps.**

# Project Structure:
* Webapp(app artifact)
  * .github(github actions workflows)  
  * node.js app files
  * gcp-packer(Packer config files)
* tf-gcp-infra(Terraform config Files)


# Topics Covered:
* DevOps, GitOps, SRE
* Linux, Shell Scripting
* Version Control with Git
* Computer Networking
* Cloud Computing
* Microservices Architecture
* Identity & Access Management
* Infrastructure as Code
* Cloud Storage Solutions
* Continuous Integration, Continuous Delivery, and Continuous Deployment
* Operational Visibility (Logging, Metrics, Monitoring, and Alerting)
* Load Balancers
* Auto-scaling Applications
* Event-driven Architecture
* Serverless Computing
* Securing cloud applications and infrastructure

# Stages for Development Evolutions:
1. 
Setup local development environment and sign up for cloud & SaaS services the project needs to use
* github organization repo
* GCP
* Terraform usage 

2. 
Build an node.js app with several APIs, choose ORM and database

3. 
* Set up <GitHub Repository Branch Protection Rules> for the organization repo, fork the repo and work on the forked one
* Work on retails of RESTful APIs and basic authentication
* Implement Continuous Integration (CI) with GitHub Actions Status Check workflow

4. 
Infrastructure as Code: 
* Install gcloud CLI
* Enable GCP Service APIs
* Setup networking resources such as Virtual Private Cloud (VPC), Internet Gateway, Route Table, and Routes using Terraform
* Implement integration tests in GitHub Actions workflow

5. 
Build Custom Application Images using Packer
* Create systemd service file to /etc/systemd/system and configure it to start the service when instance is launched

6.
Auto-configure the webapp for the database server and setup autorun for our service 
* Remove the local database server installation from the custom image.
* Create CloudSQL Instance, CloudSQL Database, CloudSQL Database User and Password on GCP
* Create startup script in GCE instance to connect the app with CloudSQL Instance

7. DNS setup & logging & IAM roles:
* Register Domain Name using Namecheap
* Create a Public Zone & setup Nameservers for Cloud DNS
* Configure domain on Namecheap to use custom name servers provided by Cloud DNS
* Update Terraform to point the domain to the VM

Application Logging & Metrics
* Write Structured Logs of the webapp in JSON
* install the Ops Agent in custom image and Create a config.yaml file to use application logs, now all log data should be available in Log Explorer on GCP
* Create a Service Account, bind IAM Roles to it and attach the Service Account to VM































