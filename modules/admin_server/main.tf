
resource "aws_iam_instance_profile" "admin_role" {
  name = var.instance.name
  role = var.parent_context.admin_role_name
}

resource "aws_instance" "admin" {
    ami                         = var.instance.ami_id
    instance_type               = var.instance.instance_type
    key_name                    = var.instance_context.ssh_key_pair_name
    vpc_security_group_ids      = [ aws_security_group.admin_sg.id ]
    subnet_id                   = var.parent_context.selected_subnet.id
    iam_instance_profile        = aws_iam_instance_profile.admin_role.name
    associate_public_ip_address = true

    user_data = <<-EOF
                #!/bin/bash
                set -eu
                trap "{ echo 'ERROR - install failed' ; exit 255; }" SIGINT SIGTERM INT TERM ERR

                # ansible and other packages
                apt-get update --quiet --assume-yes
                apt-get install --quiet --assume-yes  aptitude
                DEBIAN_FRONTEND=noninteractive aptitude install --quiet --assume-yes  tzdata # wierd behavior of tzdata implies by a listed package
                aptitude install --quiet --assume-yes inetutils-traceroute awscli  git unzip wget curl graphviz jq python3-pip

                # ansible latest
                apt-get --assume-yes install software-properties-common
                apt-add-repository ppa:ansible/ansible -y
                apt-get --assume-yes update
                apt-get --assume-yes install ansible

                sudo -s -u ubuntu pip3 install jmespath

                # terraform
                cd /home/ubuntu
                wget -O terraform.zip  https://releases.hashicorp.com/terraform/0.12.18/terraform_0.12.18_linux_amd64.zip
                unzip terraform.zip
                mkdir -p /opt/terraform
                rsync -avh terraform /opt/terraform/
                rm terraform.zip
                rm -rf terraform
                sudo -u ubuntu echo PATH="$PATH:/opt/terraform/" >> /home/ubuntu/.profile

                # configure git to use role credentials
                # make sure the role has the a policy to access the repo
                sudo -s -u ubuntu git config --global credential.helper '!aws codecommit credential-helper $@'
                sudo -s -u ubuntu git config --global credential.UseHttpPath true

                # clone IAC repo
                sudo -i -u ubuntu git clone https://git-codecommit.eu-west-3.amazonaws.com/v1/repos/infra

                echo "DONE"
                EOF


    tags = {
        Name        = var.instance.name
        Environment = var.parent_context.common_tags.environment
        Description = "Admin instance for provisioning and automation"
        Created-By  = var.parent_context.common_tags.creator
    }
}
