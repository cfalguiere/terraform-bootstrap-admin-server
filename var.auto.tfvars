#### Connection information :

#### Backend access configuration
# use with -var-file

# role to assume and to assign to the admin instance
admin_role_name = "<the role created by terraform-bootstrap-account>"
admin_role_arn  = "<arn of the role >"


#### Resources to be used :

# choose a range for security group inbound
local_cidr_block = "<your local IP range>"

instance_context = {
    ssh_key_pair_name   = "<name of you key in AWS>"
    subnet              = "<subnet where the admin instance will be created>"
    az                  = "<your az>"
}

#### Resources to be created :

security_group_name = "<the security group name to be created>"

admin_instance = {
    name           = "<the name of the insstance to be created>"
    ami_id         = "<the AMI to be used>" # ubuntu 18 image
    instance_type  = "<the instance type>"
}
