#---------networking/varibales.tf-----
variable "vpc_cidr" {}

variable "public_cidrs" {
    type = "list"
}

variable "accessip" {
    #can add here instance ip as of now default
}

