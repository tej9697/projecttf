provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAYSJMOVK3N5T7Z32H"
  secret_key = "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"
}

resource "aws_instance" "myec2" {

  ami           = "ami-03c7d01cf4dedc891"

  instance_type = "t2.micro"

  tags = {

    Name = "terrafrom-instance"

  }

user_data = <<-EOF



      #!/bin/bash

        sudo sudo yum install python3 -y

        sudo amazon-linux-extras install java-openjdk11 -y

     	sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

        sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

        sudo yum install jenkins -y

        sudo systemctl start jenkins

   EOF





}



resource "aws_security_group" "test1" {

  name        = "test1"

  description = "Allow inbound SSH"



  ingress {

    from_port        = 22

    to_port          = 22

    protocol         = "tcp"

    cidr_blocks      = ["0.0.0.0/0"]

    ipv6_cidr_blocks = ["::/0"]

  }

ingress {

     description = "HTTP"

     from_port   = 8080

     to_port     = 8080

     protocol    = "tcp"

     cidr_blocks = ["0.0.0.0/0"]

   }

     egress {

     from_port   = 0

     to_port     = 0

     protocol    = "-1"

     cidr_blocks = ["0.0.0.0/0"]

   }

}







resource "aws_network_interface_sg_attachment" "sg_attachment1" {

security_group_id = aws_security_group.test1.id

network_interface_id = aws_instance.myec2.primary_network_interface_id

}


