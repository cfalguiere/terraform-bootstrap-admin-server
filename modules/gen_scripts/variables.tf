variable "instance" {
  description = "aws_instance attributes"
  type     = object({
    id    = string
  })
}

variable "instance_suffix" {
  description = "suffix used in script names"
  type        = string
}

variable "output_dir" {
  description = "the folder name"
  type        = string
}

variable "parent_context" {
  description = "useful vars to share with the child module"
  type = object({
      common_tags   = object({
                            environment = string
                            creator = string
                          })
  })
}
