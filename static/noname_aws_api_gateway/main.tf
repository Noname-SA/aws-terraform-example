########################################################################
# top-level terraform to deploy noname with aws api gateway collection #
########################################################################

locals {
  # map of common tags to pass along to everybody.
  common_tags = {
    short_name  = var.short_name
    owner_email = var.owner_email
    owner_name  = var.owner_name
  }
}

module "noname-aws-api-gateway" {
  source                      = "../../modules/noname-api-gateway"
  #
  common_tags                 = local.common_tags
  noname_management_ip        = var.noname_management_ip
  noname_subnet_id            = var.noname_subnet_id
  package_url                 = var.package_url
  remote_engine_instance_type = var.remote_engine_instance_type
  noname_collector_name       = var.noname_collector_name
  remote_engine_os_type       = var.remote_engine_os_type
  noname_collector_urls       = var.noname_collector_urls
  noname_remote_engine_keys   = var.noname_remote_engine_keys
}
