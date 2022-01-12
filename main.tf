provider "aws" {
	region = "us-east-2"
}

data "aws_ami" "ubuntu_latest"{
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name  = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "ubuntu_server" {
  ami           = data.aws_ami.ubuntu_latest.id
  instance_type = "t3.micro"
  monitoring    = true

  tags = {
    Name = "Ubuntu server"
  }

  network_interface {
      network_interface_id = aws_network_interface.net.id
      device_index         = 0
    }
}


resource "aws_vpc" "vpc" {
  cidr_block = "172.16.0.0/16"
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-2a"
}


resource "aws_network_interface" "net" {
  subnet_id   = aws_subnet.subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}
