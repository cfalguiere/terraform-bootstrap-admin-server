Bootstrap Terraform backend and roles

## goals

This plan bootstraps the admin instance.

It creates an instance and installs the tools required to run terraform and ansible as well as doing admin operations.

This plan runs with assume_role and use a remote state.

Resources Created
- an ec2 instance under Ubuntu 18
- a dedicated security group (only port 22 from a given Ip range and outbound to anything)

The instance has the tools listed below
- terraform
- Ansible
- AWS CLI
- git
- graphviz
- python3

The infrastructure repository is cloned as part of the installation

## Prerequisites

The backend should have been set, especially the S3 bucket required by the remote state and the role that this plan with assume.

Run bootstrap_backend_and_iam if need be.

## Configure the plan

TODO
edit variables.rf and var-backend.tfvars


## Run the plan

terraform workspace new central-bootstrap
or
terraform workspace select central-bootstrap

terraform workspace list
  default
* central-bootstrap



Download plugins
```
$ terraform init -backend-config var-backend.auto.tfvars
```


Validate the plan syntax (optional)
```
$ terraform validate
```

Build the plan and check whether it does what you want
```
$ terraform  plan -out tfplan
```

Apply the plan
```
$ terraform apply -auto-approve tfplan
```

Waits until the instance is in state running. However user_data might be still running. In addition a successful terraform state does not tell whether the user_data script was successful.

TODO png

### validation

Please note that no .tfstate file has been created.

## validation

Please note that the .tfstate is generated locally.

You may run the tests below
- check the S3 bucket tf_terraform_envs contains states/aws_admin_instance/terraform.state
- check the instance tf_aws_admin for presence
- check that role TF-AdminProvisioningFullAccess is attached to this instance (instance Description / IAM role)
- check the security group tf_aws_admin_sg for existence
- check the instance can be reached (check next section)
- check the tools are available (check next section)

## SSH to the admin instance

Apply show the outputs. You may also show the outputs from the state (even a romote state).

```
terraform  output
log_aws_subnet_selected_cidr_block = 172.31.16.0/20
log_aws_subnet_selected_vpc_id = vpc-0ab7942f9e634fcad
tf_aws_admin_id = i-073e438354e13eb14
tf_aws_admin_public_ip = 25.161.46.128
```

for instance
```
$ ssh -l ubuntu  -i  ~/.ssh/aws-admin.pem -o "StrictHostKeyChecking no" 35.181.56.148
ubuntu@ip-172-31-21-23:~$ terraform -version
Terraform v0.12.18
ubuntu@ip-172-31-21-23:~$ ansible --version
ansible 2.5.1
  config file = /etc/ansible/ansible.cfg
  configured module search path = [u'/home/ubuntu/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python2.7/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 2.7.17 (default, Nov  7 2019, 10:07:09) [GCC 7.4.0]
```

You may also check the installation log

```
$ less /var/log/cloud-init-output.log
```
or if the user_data script is still running
```
$ tail -f /var/log/cloud-init-output.log
```

User data script is expected to log "DONE" at the end.


### ressources created

TODO

```
$ terraform  state list
data.aws_ami.ubuntu
data.aws_subnet.selected
aws_iam_instance_profile.tf_admin_role
aws_instance.tf_aws_admin
aws_security_group.tf_aws_admin_sg
aws_security_group_rule.tf_aws_admin_sg_allow_all_egress
aws_security_group_rule.tf_aws_admin_sg_allow_ssh
```

## generated graph

TODO

## Troubleshooting

To make change on the instance settings or user_data, terminate the instance in AWS console and run the plan again.

/Applications/utils/terraform refresh -var-file var-backend.tfvars -var-file var-admin-instance.tfvars -var-file var.secrets.tfvars


### ec2 role not working

aws s3 ls iac-terraform-workspaces

TODO exemple ec2 role

https://aws.amazon.com/premiumsupport/knowledge-center/access-key-does-not-exist/

ubuntu@ip-172-31-19-247:~$ aws configure list
      Name                    Value             Type    Location
      ----                    -----             ----    --------
   profile                <not set>             None    None

'AccessKeyId'
ubuntu@ip-172-31-19-247:~$ aws sts get-caller-identity

'AccessKeyId'

aws iam list-instance-profiles,
aaws iam list-instance-profiles-for-role --role-name IAC-ProvisioningFullAccess

aws iam get-instance-profile

curl 169.254.169.254/latest/meta-data/iam/info
{
  "Code" : "Success",
  "LastUpdated" : "2020-01-04T22:00:04Z",
  "InstanceProfileArn" : "arn:aws:iam::159804886027:instance-profile/iac_admin",
  "InstanceProfileId" : "AIPASKNI5BQFX37FK6MIX"

  curl 169.254.169.254/latest/meta-data/iam/security-credentials/AIPASKNI5BQFX37FK6MIX
  <?xml version="1.0" encoding="iso-8859-1"?>
  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
  	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
  <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
   <head>
    <title>404 - Not Found</title>
   </head>
   <body>
    <h1>404 - Not Found</h1>
   </body>
  </html>


  curl 169.254.169.254/latest/meta-data/iam/security-credentials/IAC-ProvisioningFullAccess
{
  "Code" : "AssumeRoleUnauthorizedAccess",
  "Message" : "EC2 cannot assume the role IAC-ProvisioningFullAccess.  Please see documentation at http://docs.amazonwebservices.com/IAM/latest/UserGuide/RolesTroubleshooting.html.",
  "LastUpdated" : "2020-01-04T22:10:26Z"

  https://docs.aws.amazon.com/IAM/latest/UserGuide/troubleshoot_roles.html

## Destroy

Warning : by destroying this plan you will erase the admin instance as well as all the configurations and states that may lie on this instance.

```
$ terraform destroy -auto-approve
```
