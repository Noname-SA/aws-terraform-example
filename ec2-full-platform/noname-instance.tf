terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

#Creation of VPC
resource "aws_vpc" "noname_vpc" {
  cidr_block       = var.noname_cidr
  instance_tenancy = "default"
  tags = {
    Name = "${var.name_prefix}-vpc"
  }
}

#Creation of Internet Gateway
resource "aws_internet_gateway" "noname_gw" {
  vpc_id = aws_vpc.noname_vpc.id
  tags = {
    Name = "${var.name_prefix}-gw"
  }
}

# Creation of Subnet
resource "aws_subnet" "noname_subnet" {
  vpc_id            = aws_vpc.noname_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.aws_az
  tags = {
    Name = "${var.name_prefix}-subnet"
  }
}

# Creation of Route Table
resource "aws_route_table" "noname_routetable" {
  vpc_id = aws_vpc.noname_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.noname_gw.id
  }
  tags = {
    Name = "${var.name_prefix}-routetable"
  }
}

# Get the IP address of the person running terraform script (used to allow SSH; remove from Security Group if requiring VPN)
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

# Creation of Security Group
resource "aws_security_group" "noname_security_group" {
  name        = "${var.name_prefix}-sg"
  description = "Allow inbound HTTPS traffic and outbound all "
  vpc_id      = aws_vpc.noname_vpc.id
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.noname_cidr, "${chomp(data.http.myip.body)}/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.name_prefix}-sg"
  }
}

# Associate route table with subnet
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.noname_subnet.id
  route_table_id = aws_route_table.noname_routetable.id
}

# Grabs the AMI for the latest Amazon Linux 2
data "aws_ami" "amazon-2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

# Grab the AMI for the latest Ubuntu canonical
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Grab the AMI for the latest RHEL
data "aws_ami" "rhel" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-7.?*GA*"]
  }

  owners = ["309956199498"]
}

# Create the EC2 instance and install Noname
resource "aws_instance" "nonameserver" {
  depends_on        = [aws_internet_gateway.noname_gw]
  ami               = var.os_type == "AWS" ? "${data.aws_ami.amazon-2.id}" : (var.os_type == "UBUNTU" ? "${data.aws_ami.ubuntu.id}" : "${data.aws_ami.rhel.id}")
  instance_type     = "m5.2xlarge"
  subnet_id         = aws_subnet.noname_subnet.id
  availability_zone = var.aws_az
  root_block_device {
    encrypted = true
    tags = {
      name = "noname-vol"
    }
    volume_size = "250"
    volume_type = "gp2"
  }
  security_groups = [
    aws_security_group.noname_security_group.id
  ]
  source_dest_check = "false"
  tags = {
    Name = "${var.name_prefix}-Server"
  }
  key_name = var.noname_key_name
  user_data = templatefile("${path.module}/scripts/ec2_setup_${var.os_type}.sh", {
    package_url : var.package_url
  })
}

# Create and assign Elastic IP
resource "aws_eip" "noname_eip" {
  vpc      = true
  instance = aws_instance.nonameserver.id
  tags = {
    Name = "${var.name_prefix}-eip"
  }
  depends_on = [
    aws_instance.nonameserver
  ]
}
