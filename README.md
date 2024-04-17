# Network Structure & Cloud Computing Project
Inside each folder, there is README.md file containing way more detailed configurations and steps.

# Project Structure:
* Webapp(app artifact)
  * .github(github actions workflows)  
  * node.js app files
  * gcp-packer(Packer config files)
* tf-gcp-infra(Terraform config Files)
* Serverless function

# Topics Covered:
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


# Stages for Development Evolutions:

1. Setup local development environment and sign up for cloud & SaaS services the project needs to use
* github organization repo, forked personal repo
* GCP account
* Terraform usage 

2. Build an node.js app with several APIs, choose ORM and database
* Set up <GitHub Repository Branch Protection Rules> for the organization repo, fork the repo and work on the forked one
* Work on retails of RESTful APIs and basic authentication
* Implement Continuous Integration (CI) with GitHub Actions Status Check workflow

3. Infrastructure as Code: 
* Install gcloud CLI
* Enable GCP Service APIs
* Setup networking resources such as Virtual Private Cloud (VPC), Internet Gateway, Route Table, and Routes using Terraform
* Implement integration tests in GitHub Actions workflow

4. Build Custom Application Images using Packer
* Create systemd service file to /etc/systemd/system and configure it to start the service when instance is launched

5. Auto-configure the webapp for the cloud database and setup autorun for our service 
* Remove the local database server installation from the custom image.
* Create CloudSQL Instance, CloudSQL Database, CloudSQL Database User and Password on GCP
* Create startup script in GCE instance to connect the app with CloudSQL Instance

6. DNS setup & IAM roles:
* Create a Public Zone with the domain name & setup Nameservers for Cloud DNS
* Configure Namecheap to use custom name servers provided by Cloud DNS to use the Cloud DNS name servers
* Configure records(CNAME,TXT,A, MX) needed and provided by Namecheap, on GCP
* Update A record on Terraform to point the domain to the VM

Check domain and record mapping: 
[Google Apps Toolbox](https://toolbox.googleapps.com/apps/dig/#A/)
[Namechimp][https://www.namecheap.com]

7.Application Logging & Metrics
* Write Structured Logs of the webapp in JSON
* Install the Ops Agent in custom image and Create a config.yaml file to use application logs, now all log data should be available in Log Explorer on GCP
* Create a Service Account, bind IAM Roles to it and attach the Service Account to VM(Logging Admin/ Monitoring Metric Writer)

8. Cloud Functions
* When a new user account is created, a message will be sent to the topic
* The Cloud Function will be invoked by the pub/sub
* An email will be sent to the user with a link they can click to verify their email address
[Mailgun][https://www.mailgun.com]

9. Load balancer and Auto-scaling
* Create a regional compute instance template
* Create a compute health check
* Create a regional compute instance group manager with the template
* Create a compute autoscaler
* Create a external Application Load Balancers which only support HTTPS protocol by using SSL certificate
* Update the DNS record to point the domain to load balancer IP address. Public IPs of the virtual machines won't be accessible

10. Cloud Key Management Service
* Create king ring and keys ann bind them to VM and CloudSQL
* Update ci/cd workflow, create a new vm template with the new image using gcloud cli, update the auto-scaler with new template



























