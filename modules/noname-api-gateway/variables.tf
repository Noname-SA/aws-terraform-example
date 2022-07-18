#######################################################
# variables for noname-remote-engine terraform module #
#######################################################

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

variable "name_prefix" {
  type        = string
  default     = "noname"
  description = "Prefix to use when naming all created resources"
}

variable "noname_management_ip" {
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

variable "remote_engine_os_type" {
  type        = string
  description = "OS type to run noname remote engine, one of AWS|RHEL|UBUNTU"
  default     = "AWS"
}

variable "noname_collector_name" {
  type        = string
  description = "remote platform name"
}

variable "noname_collector_urls" {
  type        = string
  description = "remote platform urls to pass to remote platform"
}

variable "noname_remote_engine_keys" {
  type        = string
  description = "remote engine keys"
}
