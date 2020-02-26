# create scripts

locals {
  producer = var.parent_context.common_tags.creator
  templates_path = "${path.module}/templates"
}

resource "local_file" "stop_instance" {
    content     = templatefile(
                      "${local.templates_path}/stop-instance.tmpl",
                      {
                            producer = local.producer
                            instance_id = var.instance.id
                      })
    filename    = "${var.output_dir}/stop-instance-${var.instance_suffix}.sh"
    file_permission = "0700" # u=rwx
}

resource "local_file" "start_instance" {
    content     = templatefile(
                      "${local.templates_path}/start-instance.tmpl",
                      {
                            producer = local.producer
                            instance_id = var.instance.id
                      })
    filename    = "${var.output_dir}/start-instance-${var.instance_suffix}.sh"
    file_permission = "0700" # u=rwx
}
