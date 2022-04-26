# Prefix to use when naming all created resources
variable "name_prefix" {
  type    = string
  default = "###"
}

# Package URL provided by Noname. Must match OS deployment type - see AMI in .tf
variable "package_url" {
  type    = string
  default = "###"
}

# Set this variable to UBUNTU, RHEL, or AWS
variable "os_type" {
  type    = string
  default = "UBUNTU"
}

# Access key for aws access
variable "access_key" {
  type    = string
  default = "###"
}

# Secret key for aws access
variable "secret_key" {
  type    = string
  default = "###"
}

# Key used for SSH; assuming key is already in AWS Account
variable "noname_key_name" {
  type    = string
  default = "###"
}

# Deployment region
variable "aws_region" {
  type    = string
  default = "us-east-2"
}

# Availability zone within region
variable "aws_az" {
  type    = string
  default = "us-east-2a"
}

# CIDR for new Noname subnet
variable "noname_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
