#######################################################
# variables for noname-remote-engine terraform module #
#######################################################

variable "aws_availability_zone" {
  type        = string
  description = "name of desired aws availability zone"
}

variable "name_prefix" {
  type        = string
  default     = "noname"
  description = "Prefix to use when naming all created resources"
}

variable "noname_management_host" {
  type        = string
  description = "Management host for Noname"
}

variable "noname_subnet_id" {
  type        = string
  description = "subnet ID to set up network assets for noname remote engine"
}

variable "package_url" {
  type        = string
  description = "Package URL provided by Noname. Must match OS deployment type - see AMI in .tf"
}

variable "remote_engine_instance_type" {
  type        = string
  description = "instance type for remote engine ec2 instance"
  default     = "m5.2xlarge"
}

variable "remote_engine_name" {
  type        = string
  description = "remote engine name"
}

variable "remote_engine_urls" {
  type        = string
  description = "remote engine urls to pass to remote engine"
}
