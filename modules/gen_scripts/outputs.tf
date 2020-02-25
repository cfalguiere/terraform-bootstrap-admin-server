
# return role

output "stop_filename" {
  value       = local_file.stop_instance.filename
  description = "stop script"
}

output "start_filename" {
  value       = local_file.start_instance.filename
  description = "start script"
}
