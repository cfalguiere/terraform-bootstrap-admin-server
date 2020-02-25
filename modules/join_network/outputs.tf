
# return subnet

output "selected_subnet" {
  value       = data.aws_subnet.selected
  description = "Selected subnet"
}
