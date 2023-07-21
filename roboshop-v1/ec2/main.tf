resource "aws_instance" "web" {
  ami = data.aws_ami.example.id
  instance_type = "t3.small"
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = var.name
  }
}

resource "null_resource" "ansible" {
depends_on= [aws_instance.web, aws_route53_record.www]  
provisioner "remote-exec" {
    connection {
    type     = "ssh"
    user     = "centos"
    password = "DevOps321"
    host     = aws_instance.web.public_ip
    }
      inline = [
      "sudo labauto ansible",
      "ansible-pull -i localhost, -U https://github.com/raghudevops73/roboshop-ansible main.yml -e env=dev -e role=${var.name}"
       ]
}
}

data "aws_ami" "example" {
  most_recent = true
  owners = ["192494896405"]
  name_regex = "Centos-8-DevOps-Practice"
}

resource "aws_route53_record" "www" {
  zone_id = "Z08003803OC4Y6A8SK8BX"
  name    = "${var.name}-dev"
  type    = "A"
  ttl     = 30
  records = [aws_instance.web.private_ip]
}

resource "aws_security_group" "sg" {
  name = var.name
  description = "Allow TLS inbound traffic"

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.name 
  }
}

variable "name" {}

