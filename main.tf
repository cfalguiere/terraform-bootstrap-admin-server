

terraform {
  required_version = ">= 0.12.18"
  backend "s3" {}
}

provider "aws" {
  version = "~> 2.0"
  region  = var.region

  # must provide these information again in order to be able to assume role
  profile  = var.profile
  shared_credentials_file = var.shared_credentials_file

  assume_role {
    role_arn     = var.admin_role_arn
    session_name = formatdate("YYYYMMDD-hhmmss", timestamp() )
    external_id  = var.profile
  }
}

locals {
  common_tags = {
    environment = terraform.workspace
    creator     = "Terraform ${terraform.workspace} ${var.profile}"
  }
}

/*
  sub modules
*/

# lookup a subnet

module "selected_network" {
  source = "./modules/join_network"

  subnet_id = var.instance_context.subnet
  az        = var.instance_context.az
}


# create the admin instance

module "admin_server" {
  source = "./modules/admin_server"

  instance = var.admin_instance
  instance_context = var.instance_context
  security_group_name = var.security_group_name
  local_cidr_block = var.local_cidr_block

  parent_context =  {
      common_tags = local.common_tags
      selected_subnet = module.selected_network.selected_subnet
      admin_role_name = var.admin_role_name
  }

}


# output start/stop scripts

module "gen_scripts" {
  source = "./modules/gen_scripts"

  instance = module.admin_server.current
  instance_suffix = var.admin_instance.name
  output_dir = var.output_dir

  parent_context =  {
      common_tags = local.common_tags
  }

}
