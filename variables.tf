# Bootstrap backend and iam

#### variables loaded from backend config

variable region {
  type = string
}
variable profile {
  type = string
}
variable shared_credentials_file {
  type = string
}
variable key {
  type = string
}
variable admin_role_name {
  type = string
}
variable admin_role_arn {
  type = string
}

variable "bucket" {} # not used - ignore warning

#### Resources to be used :

locals {
  environment = "central-bootstrap-local" # no workspace yet
  creator     = "Terraform ${local.environment} ${var.profile}"
}

variable "instance_context" {
  description = "ressources associated with this instance (should exist)"
  type     = object({
    ssh_key_pair_name   = string
    subnet              = string
    az                  = string
  })
}

# this repo will be cloned onto the admin server
variable "iac_scripts_repo_url" {
  description = "a repo name for iac scripting"
  type        = string
}

variable "output_dir" {
  description = "folder into which the scripts will be written"
  type        = string
  default     = "./out"
}

variable "local_cidr_block" {
  description = "authorized CIDR block"
  type        = string
}

#### Resources to be created :


variable "security_group_name" {
  description = "a security group name to be created"
  default     = "iac_admin_sg"
}

variable "admin_instance" {
  description = "aws_instance attributes"
  type     = object({
    name           = string
    ami_id         = string
    instance_type  = string
  })
}
