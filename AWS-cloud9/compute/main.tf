#--compute/main.tf----

data "aws_ami" "server_ami" {
    most_recent = true #this ensures most recent for the region. find right ami for rigt region
    owners = ["amazon"]
    
    filter {
        name = "owner-alias"
        values = ["amazon"] #only want ami owned by amazons 
    }
    
    filter {
        name = "name"
        values = ["amzn-ami-hvm*-x86_64-gp2"] #for every single one of amazaon linux ami
    }
}

resource "aws_key_pair" "tf_auth" {
    key_name = "${var.key_name}"
    public_key = "${file(var.public_key_path)}"
}

data "template_file" "user-init" {
    count = 2
    template = "${file("${path.module}/userdata.tpl")}" #module picks from this path 
    
    vars {
        firewall_subnets = "${element(var.subnet_ips, count.index)}"
    }
}

resource "aws_instance" "tf_server" {
    count = "${var.instance_count}"
    instance_type = "${var.instance_type}"
    ami = "${data.aws_ami.server_ami.id}"
    tags {
        Name = "tf_server-${count.index+1}"
    }
    
    key_name = "${aws_key_pair.tf_auth.id}"
    vpc_security_group_ids = ["${var.security_group}"]
    subnet_id = "${element(var.subnets, count.index)}" #subnets will be output from networking module and two subnets created with elements syntax 
    user_data = "${data.template_file.user-init.*.rendered[count.index]}" #for each index nuber in count creating a new template that referecnes subnet ip with each indivial instance.
}




