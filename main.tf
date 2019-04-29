provider "aws" {
    region = "${var.aws_region}"
}

#deplpoy storage resources
module "storage" {
    source = "./storage"
    project_name = "${var.project_name}"
}

#working



