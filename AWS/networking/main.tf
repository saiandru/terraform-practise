#-----networking/main.tf------

#need to create dataresource--queries data and resources from aws data 

data "aws_availability_zones" "available" {}

resource "aws_vpc" "tf_vpc" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    enable_dns_support = true
    
    tags{
        Name = "tf_vpc"
    }
}


resource "aws_internet_gateway" "tf_internet_gateway" {
    vpc_id = "${aws_vpc.tf_vpc.id}"
    
    tags {
        Name = "tf_igw"
    }
}


resource "aws_route_table" "tf_public_rt" {
    vpc_id = "${aws_vpc.tf_vpc.id}"
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.tf_internet_gateway.id}"
        
    }
        tags {
            Name = "tf_public"
        }
}


#private route table

resource "aws_default_route_table" "tf_private_rt" {
    default_route_table_id = "${aws_vpc.tf_vpc.default_route_table_id}"

    tags {
        Name = "tf_private"
    }
}


#subnets

resource "aws_subnet" "tf_public_subnet" {
    count = 2
    vpc_id = "${aws_vpc.tf_vpc.id}"
    cidr_block = "${var.public_cidrs[count.index]}" #here referencing list of cidrs
    #its like tf_pubclic_subnet0 is named in count 
    map_public_ip_on_launch = true
    availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

    tags {
        Name = "tf_public_${count.index + 1}"
    }
}

resource "aws_route_table_association" "tf_public_assoc" {
    count = "${aws_subnet.tf_public_subnet.count}"
    subnet_id = "${aws_subnet.tf_public_subnet.*.id[count.index]}" #* is count utilzation and matches to 0 and 1
    route_table_id = "${aws_route_table.tf_public_rt.id}"
}

resource "aws_security_group" "tf_public_sg" {
    name = "tf_public_sg"
    description = "used for access to the public instances"
    vpc_id = "${aws_vpc.tf_vpc.id}"
    
    #SSH
    
    ingress {
        from_port = 22
        to_port =22
        protocol = "tcp"
        cidr_blocks = ["${var.accessip}"] #plural means  square brackets
    }
    
    
    #HTTP
    
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["${var.accessip}"]
    }
    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1" #allows all poroctocl tcp,udp etc
        cidr_blocks = ["0.0.0.0/0"]
    }
}




