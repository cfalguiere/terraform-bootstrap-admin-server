
# lookup a subnet

data "aws_subnet" "selected" {
  availability_zone = var.az
  id                = var.subnet_id
}
