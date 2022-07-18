####################################################################
# top-level terraform to deploy noname with aws traffic mirroring. #
####################################################################

locals {
  # map of common tags to pass along to everybody.
  common_tags = {
    short_name  = var.short_name
    owner_email = var.owner_email
    owner_name  = var.owner_name
  }
}

module "noname-remote-engine" {
  source                      = "../../modules/noname-remote-engine"
  #
  common_tags                 = local.common_tags
  noname_management_host      = var.noname_management_host
  noname_subnet_id            = var.noname_subnet_id
  package_url                 = var.package_url
  remote_engine_instance_type = var.remote_engine_instance_type
  remote_engine_name          = var.remote_engine_name
  remote_engine_os_type       = var.remote_engine_os_type
  remote_engine_urls          = var.remote_engine_urls
}
