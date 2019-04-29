#-----storage/outputs.tf---

output "Bucker Name" {
    value = "${module.storage.bucketname}"
}

