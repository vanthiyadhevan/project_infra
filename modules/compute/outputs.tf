# jenkins output values
output "jenkins_instance_id" {
  value       = aws_instance.jenkins_instance.id
  description = "jenkins instance id"
}
output "jenkins_pub_ip" {
  value       = aws_instance.jenkins_instance.public_ip
  description = "jenkins public ip address"
}
output "jenkins_security_groups" {
  value       = aws_instance.jenkins_instance.security_groups
  description = "jenkins instance security group"
}
output "jenkins_subnet_id" {
  value       = aws_instance.jenkins_instance.subnet_id
  description = "jenkins subnet id"
}


# sonar qube output values
output "sonar_qube_instance_id" {
  value       = aws_instance.sonar_qube_instance.id
  description = "sonarqube instance id"
}
output "sonar_pub_ip" {
  value       = aws_instance.sonar_qube_instance.public_ip
  description = "sonar qube public ip"
}
output "sonar_qube_security_group" {
  value       = aws_instance.sonar_qube_instance.security_groups
  description = "sonarqube instance security group"
}
output "sonar_qube_subnet_id" {
  value       = aws_instance.sonar_qube_instance.subnet_id
  description = "sonar qube subnet id"
}

# jump host output values
output "jump_host_instance_id" {
  value       = aws_instance.jump_host_instance.id
  description = "jump host instance id"
}
output "jump_host_pub_ip" {
  value       = aws_instance.jump_host_instance.public_ip
  description = "jump host public ip addr"
}
output "jump_host_security_group" {
  value       = aws_instance.jump_host_instance.security_groups
  description = "jump host instance security group"
}
output "jump_host_subnet_id" {
  value       = aws_instance.jump_host_instance.subnet_id
  description = "jump host subnet id"
}
