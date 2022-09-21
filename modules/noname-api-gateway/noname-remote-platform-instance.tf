######################################################
# module to provision/configure noname security      #
# remote _platform_ for AWS API Gateway integration. #
######################################################
#
# adapted from https://github.com/Noname-SA/aws-terraform-example/blob/master/ec2-remote-engine/noname-instance.tf
#

# not plumbing up ssh access, and certainly not to the host running terraform!
#
# Get the IP address of the person running terraform script (used to allow SSH; remove from Security Group if requiring VPN)
#data "http" "my_ip" {
#  url = "http://ipv4.icanhazip.com"
#}

# Creation of Security Group -- we may not need this at all,
# as long as the egress is OK.  Internal access from inside
# the VPC may suffice.

resource "aws_security_group" "noname_security_group" {
  name        = "${var.name_prefix}-sg"
#  name        = "${var.name_prefix}-sg"
  description = "Security Group for Noname Remote Platform"
  vpc_id      = data.aws_vpc.target.id
#  ingress {
#    description = "HTTPS"
#    from_port   = 443
#    to_port     = 443
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#  ingress {
#   description = "SSH"
#    from_port   = 22
#    to_port     = 22
#    protocol    = "tcp"
#    cidr_blocks = [var.noname_cidr, "${chomp(data.http.my_ip.body)}/32"]
#  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.common_tags, { Name = "${var.name_prefix}-sg" } )
}

# get the AMI for the latest Amazon Linux 2
data "aws_ami" "amazon-2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

# get the AMI for the latest Ubuntu canonical
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

################################################
# create IAM role for noname server so that it #
# can access api server and cloud watch logs.  #
################################################
resource "aws_iam_role" "noname_cloudwatch_role" {
  name = "${var.name_prefix}-cloudwatch-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

#############################################
# Create aws policy to allow noname server  #
# to access api gateway and cloudwatch logs #
#############################################
resource "aws_iam_policy" "noname_cloudwatch_policy" {
  name   = "${var.name_prefix}-cw-policy"
  path   = "/acct-managed/"  # magic pathname
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid      = "NonameSecurityApiGateway",
        Effect   = "Allow",
        Resource = "*"
        Action   = [
          "apigateway:GET",
          "cloudwatch:Describe*",
          "cloudwatch:Get*",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:List*",
          "cloudwatch:ListMetrics",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:GetLogEvents",
          "logs:Describe*",
          "logs:FilterLogEvents",
          "logs:Get*",
          "logs:List*",
          "logs:StartQuery",
          "logs:StopQuery",
          "logs:TestMetricFilter"
        ]
      }
    ]
  })
}

#################
# Attach policy #
#################
resource "aws_iam_role_policy_attachment" "cloudwatch-role-attach" {
  role       = aws_iam_role.noname_cloudwatch_role.name
  policy_arn = aws_iam_policy.noname_cloudwatch_policy.arn
}

##############################################
# Create the EC2 instance and install Noname #
##############################################
resource "aws_instance" "noname_server" {
  ami                  = var.remote_engine_os_type == "AWS" ? data.aws_ami.amazon-2.id : data.aws_ami.ubuntu.id
  instance_type        = var.remote_engine_instance_type
  subnet_id            = var.noname_subnet_id
  availability_zone    = var.aws_availability_zone
  iam_instance_profile = aws_iam_role.noname_cloudwatch_role.name
  root_block_device {
    encrypted   = true
    tags        = merge(var.common_tags, { name = "noname-vol" } )
    volume_size = "250"
    volume_type = "gp2"
  }
  security_groups = [
    aws_security_group.noname_security_group.id
  ]
  source_dest_check = "false"
  tags              = merge(var.common_tags, { Name = "${var.name_prefix}-remote-platform" } )
  user_data         = templatefile("${path.module}/scripts/ec2_setup_${var.remote_engine_os_type}.sh", {
    package_url : var.package_url,
    management_ip : var.noname_management_ip,
    collector_name : var.noname_collector_name,
    collector_urls : var.noname_collector_urls,
    remote_keys : var.noname_remote_engine_keys
  })
}
