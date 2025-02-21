output "instance_ip" {
  description = "Public IP of the web server"
  value       = aws_instance.web.public_ip
}
