# return role

output "admin_server_public_ip" {
  value       = module.admin_server.current.public_ip
  description = "Public IP of Admin server"
}

output "admin_server_private_ip" {
  value       = module.admin_server.current.private_ip
  description = "Public IP of Admin server"
}

output "scripts_dir" {
  value       = var.output_dir
  description = "start stop scripts"
}
