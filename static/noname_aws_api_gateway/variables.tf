#
#
# vars for common tags
#
variable "short_name" {
  description = "This is the unique identifier for your application"
  default = "test-noname-api-gateway"
}

# Update 'owner_email' with a default value
variable "owner_email" {
  description = "The email address for your team"
  default = "Tag added with owner email address"
}

# Update 'owner_name' with a default value
variable "owner_name" {
  description = "Your team name"
  default = "Product-Security-Engineering"
}

#
# variables for noname deployment
#
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

variable "noname_collector_name" {
  type        = string
  description = "remote engine name"
}

variable "remote_engine_os_type" {
  type        = string
  description = "OS type to run noname remote engine, one of AWS|RHEL|UBUNTU"
  default     = "AWS"
  validation {
    condition     = contains(["AWS", "RHEL", "UBUNTU"], var.remote_engine_os_type)
    error_message = "remote engine OS type must be AWS RHEL or UBUNTU"
  }
}

variable "noname_collector_urls" {
  type        = string
  description = "remote engine urls to pass to remote engine"
}

variable "noname_remote_engine_keys" {
  type        = string
  description = "remote engine keys"
}

