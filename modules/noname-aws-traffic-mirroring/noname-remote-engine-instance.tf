#
# provision a noname remote engine instance.
#


# As long as the remote engine is receiving traffic from within the same VPC, only egress is required

resource "aws_security_group" "noname_security_group" {
  name        = "${var.name_prefix}-sg"
  description = "Allow outbound traffic"
  vpc_id      = data.aws_vpc.target.id
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

# Grab the AMI for the latest Ubuntu canonical
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20220419"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Create the EC2 instance and install Noname
resource "aws_instance" "noname_server" {
  ami               = data.aws_ami.ubuntu.id
  instance_type     = var.remote_engine_instance_type
  subnet_id         = var.noname_subnet_id
  availability_zone = var.aws_availability_zone
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
    Name = "${var.name_prefix}-remote-engine"
  }
  user_data = templatefile("${path.module}/scripts/ec2_setup_UBUNTU.sh", {
    package_url : var.package_url,
    noname_management_host : var.noname_management_host,
    remote_engine_name : var.remote_engine_name
    remote_engine_urls : var.remote_engine_urls
  })

}