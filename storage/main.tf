#-----------storage/main.tf-------------
#create a random id #so as to prevent it from world as it sould be uniquue

resource "random_id" "tf_bucket_id" {
    byte_length = 2
}

#create the bucket
resource "aws_s3_bucket" "tf_code" {
    bucket = "${var.project_name}-${random_id.tf_bucket_id.dec}"
    acl = "private"
    force_destroy = true #we cant delete remotely have to do manual without this
    
    tags {
        Name = "tf_bucket"
    }
}