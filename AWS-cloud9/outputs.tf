#-----root/outputs.tf---------
#-----storage/outputs.tf---

output "Bucket Name" {
    value = "${module.storage.bucketname}"
}

#---------networking outputs
output "Public Subnets" {
    value = "${join(", ", module.networking.public_subnets)}"
}

output "Subnet ips" {
    value = "${join(", ", module.networking.subnet_ips)}"
}

output "Public Security Group" {
    value = "${module.networking.public_sg}"
}

#-----compute outputs

output "Public Instance Ids" {
    value = "${module.compute.server_id}"
}

output "Public instance ips" {
    value = "${module.compute.server_ip}"
}


