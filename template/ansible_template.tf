variable "gcp_region" { type = string }
variable "gcp_zone" { type = string }
variable "gcp_project" { type = string }
variable "gcp_auth_file" { type = string }
variable "bucket-name" { type = string }
variable "storage-class" { type = string }

terraform {
  backend "gcs" {
    bucket      = @bucket-name
    prefix      = "template"
  }
}

provider "google" {
  credentials = file(var.gcp_auth_file)
  project     = var.gcp_project
  region      = var.gcp_region
}


data "terraform_remote_state" "compute" {
 backend = "gcs"
 config = {
    bucket      = @bucket-name
    prefix      = "compute"
}
}

data "template_file" "ansible_template" {
  template = file("./ansible_template.cfg")
  vars = {
    airflow = data.terraform_remote_state.compute.outputs.airflow
    postgres-kafka-nifi = data.terraform_remote_state.compute.outputs.postgres_kafka_nifi
}
}

resource "null_resource" "hosts" {
  triggers = {
    template_rendered = data.template_file.ansible_template.rendered
  }
  provisioner "local-exec" {
    command = "echo '${data.template_file.ansible_template.rendered}' > /opt/bootstrap/hosts" 
 }
}
