output "my_ip_addr" {
  value = var.my_ip
}
output "jenkins_sg" {
  value = aws_security_group.jenkins.id
}