# ----------------------------
# Jenkins Security Group
# ----------------------------
resource "aws_security_group" "jenkins" {
  name        = var.jenkins_sec_grp_name
  description = "Allow Jenkins to access from 8080"
  vpc_id      = data.aws_vpc.vpc_main.id

  tags = {
    Name        = var.jenkins_sec_grp_name
    Environment = var.environment
  }
}

# Jenkins ingress rule for browser access (only from my_ip)
resource "aws_vpc_security_group_ingress_rule" "jenkins_browser_access" {
  security_group_id = aws_security_group.jenkins.id
  cidr_ipv4         = var.my_ip
  from_port         = var.jenkins_port
  to_port           = var.jenkins_port
  ip_protocol       = var.ip_protocol_name
}

# Jenkins ingress rule for SSH access (only from my_ip)
resource "aws_vpc_security_group_ingress_rule" "jenkins_ssh_access" {
  security_group_id = aws_security_group.jenkins.id
  cidr_ipv4         = var.my_ip
  from_port         = var.ssh_access_for_sg
  to_port           = var.ssh_access_for_sg
  ip_protocol       = var.ip_protocol_name
}

# Jenkins egress rule (allow all outbound traffic)
resource "aws_vpc_security_group_egress_rule" "jenkins_egress" {
  security_group_id = aws_security_group.jenkins.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# ----------------------------
# Jump Host Security Group
# ----------------------------
resource "aws_security_group" "jump_host" {
  name        = var.jump_host_name
  description = "Allow Jump Host for SSH"
  vpc_id      = data.aws_vpc.vpc_main.id

  tags = {
    Name        = var.jump_host_name
    Environment = var.environment
  }
}

# Jump Host ingress rule (only from my_ip)
resource "aws_vpc_security_group_ingress_rule" "jump_host_ingress_rule" {
  security_group_id = aws_security_group.jump_host.id
  cidr_ipv4         = var.my_ip
  from_port         = var.ssh_access_for_sg
  to_port           = var.ssh_access_for_sg
  ip_protocol       = var.ip_protocol_name
}

# Jump Host egress rule (allow all outbound traffic)
resource "aws_vpc_security_group_egress_rule" "jump_host_egress" {
  security_group_id = aws_security_group.jump_host.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# ----------------------------
# SonarQube Security Group
# ----------------------------
resource "aws_security_group" "sonar_qube" {
  name        = var.sonar_qube_name
  description = "Allow SonarQube browser access"
  vpc_id      = data.aws_vpc.vpc_main.id

  tags = {
    Name        = var.sonar_qube_name
    Environment = var.environment
  }
}

# SonarQube ingress rule (only from my_ip)
resource "aws_vpc_security_group_ingress_rule" "sonar_ingress_rule" {
  security_group_id = aws_security_group.sonar_qube.id
  cidr_ipv4         = var.my_ip
  from_port         = var.sonar_port
  to_port           = var.sonar_port
  ip_protocol       = var.ip_protocol_name
}

# SonarQube egress rule (allow all outbound traffic)
resource "aws_vpc_security_group_egress_rule" "sonar_egress_rule" {
  security_group_id = aws_security_group.sonar_qube.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
