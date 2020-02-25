
variable "instance" {
  description = "the instance info"
  type = object({
    name           = string
    ami_id         = string
    instance_type  = string
  })
}

variable "instance_context" {
  description = "ressources associated with this instance (should exist)"
  type     = object({
    ssh_key_pair_name   = string
    subnet              = string
    az                  = string
  })
}

variable "security_group_name" {
  description = "the security group to be created"
  type        = string
}

variable "local_cidr_block" {
  description = "the local ip to let in"
  type        = string
}

variable "parent_context" {
  description = "useful vars to share with the child module"
  type = object({
      common_tags   = object({
                            environment = string
                            creator = string
                          })
      selected_subnet = any 
      admin_role_name = string

  })
}
