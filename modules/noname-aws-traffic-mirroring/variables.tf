#######################################################
# variables for noname-remote-engine terraform module #
#######################################################

variable "name_prefix" {
  type        = string
  default     = "noname"
  description = "Prefix to use when naming all created resources"
}

variable "aws_availability_zone" {
  type        = string
  description = "name of desired aws availability zone"
  default     = "us-east-1b"
}

# map of common tags
variable "common_tags" {
  type        = map(string)
  description = "map of name/value pairs for common tags"
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
  description = "Package URL provided by Noname. Must match OS deployment type"
}

variable "remote_engine_instance_type" {
  type        = string
  description = "instance type for remote engine ec2 instance"
  default     = "m5.2xlarge"
}

# Set this variable to UBUNTU, RHEL, or AWS
variable "remote_engine_os_type" {
  type        = string
  description = "OS type to run noname remote engine, one of AWS|RHEL|UBUNTU"
  default     = "AWS"
}

variable "remote_engine_name" {
  type        = string
  default     = "remoteEngine1"
  description = "remote engine name"
}

variable "remote_engine_urls" {
  type        = string
  default     = "remoteEngine1"
  description = "remote engine urls to pass to remote engine"
}

variable "network_interface_ids" {
  type        = list(string)
  description = "List of IDs of the source networks interfaces to mirror"
}

variable "virtual_network_id" {
  type        = number
  description = "set the VXLAN ID so that Noname properly identifies the source"
  default     = 131073  # use ascending values to identify the source of the traffic
}
