# Bootstrap admin machine
# create security group

/*
  Security Group
*/

resource "aws_security_group" "admin_sg" {
    name = var.security_group_name
    description = "Access restriction to ${var.instance.name}"

    vpc_id = var.parent_context.selected_subnet.vpc_id

    tags = {
        Name        = var.security_group_name
        Environment = var.parent_context.common_tags.environment
        Description = "Access restriction to ${var.instance.name}"
        Created-By  = var.parent_context.common_tags.creator
    }
}

/*
  Inbound rules
*/

resource "aws_security_group_rule" "admin_sg_allow_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = [ var.local_cidr_block ]

  security_group_id = aws_security_group.admin_sg.id
}


/*
  Outbound rules
*/


resource "aws_security_group_rule" "admin_sg_allow_all_egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.admin_sg.id
}
