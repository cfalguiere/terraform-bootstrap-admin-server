# Created-By Terraform central-bootstrap-local iac-admin

# Backend access configuration
# use with -var-file

# role to assume and to assign to the admin instance
admin_role_name = "<the role created by terraform-bootstrap-account>"
admin_role_arn  = "<arn of the role >"

#
# This part also act as a backend configuration file
# Do not change the key names
# use with -backend-config in init
#

# choose a role associated to the ec2 instance
# make sure the role has the policy AdministratorAccess
profile  = "<the admin user name>"

# choose a role associated to the ec2 instance
shared_credentials_file  = "<the path to user's credentials>"

# make sure the bucket exists
# make user or role has access to the bucket and files
bucket = "<the terraform bucket name>"

# path to the state file inside the bucket
key = "states/terraform.state"

# choose a region
region = "<your region>
