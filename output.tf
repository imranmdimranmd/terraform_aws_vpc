output "instance_private_ip_addr" {
  value = aws_instance.main.private_ip
}
output "instance_public_ip_addr" {
  value = aws_instance.main.public_ip
}