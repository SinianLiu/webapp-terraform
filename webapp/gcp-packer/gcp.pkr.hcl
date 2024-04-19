packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/googlecompute"
      version = "~> 1"
    }
  }
}


# template.pkr.hcl
variable "project_id" {
  type    = string
  default = "dev-project-415104"
}

variable "source_image_family" {
  type    = string
  default = "centos-stream-8"
}


variable "zone" {
  type    = string
  default = "us-west1-a"
}

variable "disk_size" {
  type    = number
  default = 20
}

variable "disk_type" {
  type    = string
  default = "pd-standard"
}

variable "image_name" {
  type    = string
  default = "csye6225-{{timestamp}}"
}

# Custom image builds should be set up to run in your default VPC.
variable "network" {
  type    = string
  default = "default"
}

variable "image_family" {
  type    = string
  default = "csye6225-app-image"
}

variable "image_storage_locations" {
  type    = list(string)
  default = ["us"]
}

variable "ssh_username" {
  type    = string
  default = "packer"
}

// build custome image for GCP,
source "googlecompute" "csye6225-app-custom-image" {
  project_id          = var.project_id
  source_image_family = var.source_image_family
  zone                = var.zone
  disk_size           = var.disk_size
  disk_type           = var.disk_type
  image_name          = var.image_name
  image_family        = var.image_family
  network             = var.network

  # image_description       = "CSYE6225 Custom Image"
  image_project_id        = var.project_id
  image_storage_locations = var.image_storage_locations
  ssh_username            = var.ssh_username
}


build {
  sources = ["source.googlecompute.csye6225-app-custom-image"]

  provisioner "shell" {
    script = "osUpdate.sh"
  }

  provisioner "shell" {
    script = "user_setup.sh"
  }

  # Config the cloudSQL DB, not need to do this in the VM
  # provisioner "shell" {
  #   script = "db_setup.sh"
  # }

  provisioner "shell" {
    script = "env_setup.sh"
  }


  # transfer a folder instead of webapp.zip directly
  provisioner "file" {
    source      = "temp/"
    destination = "/tmp/"
  }

  provisioner "file" {
    source      = "webapp.service"
    destination = "/tmp/webapp.service"
  }


  provisioner "file" {
    source      = "../.env"
    destination = "/tmp/.env"
  }

  provisioner "file" {
    source      = "../config.yaml"
    destination = "/tmp/config.yaml"
  }

  provisioner "shell" {
    script = "unzip_webapp.sh"
  }

  provisioner "shell" {
    script = "ops_agent_setup.sh"
  }

  provisioner "shell" {
    script = "service_start.sh"
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }


}
