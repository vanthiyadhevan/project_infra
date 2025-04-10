# provider "aws" {
#   version = "5.90.0"
# }

# --------------------------------------
# Data Sourcing From Existing Resources
# --------------------------------------

# data "aws_vpc" "vpc_main" {
#   filter {
#     name   = "tag:Name"
#     values = ["${var.environment}-VPC"]
#   }
# }

# data "aws_subnet" "pub_subnet" {
#   filter {
#     name   = "tag:Name"
#     values = ["${var.environment}-pub-subnet-1"]
#   }

# }

# ---------------------------------
# Jenkins Security Group Creation
# ---------------------------------
resource "aws_security_group" "jenkins" {
  name        = "${var.environment}-${var.jenkins_sec_grp_name}-SG"
  description = "Allow Jenkins to access from 8080"
  # vpc_id      = data.aws_vpc.vpc_main.id
  # vpc_id      = aws_vpc.vpc_main.id
  vpc_id = var.vpc_id

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
# Jenkins ingress rule for SonarQube (only from SonarQube)
resource "aws_security_group_rule" "sonar_jenkins_access" {
  type                     = "ingress"
  from_port                = var.jenkins_port
  to_port                  = var.jenkins_port
  protocol                 = var.ip_protocol_name
  security_group_id        = aws_security_group.jenkins.id
  source_security_group_id = aws_security_group.sonar_qube.id
}
# resource "aws_vpc_security_group_ingress_rule" "sonar_jenkins_access" {
#   security_group_id = aws_security_group.jenkins.id
#   # security_groups      = [aws_security_group.sonar_qube.id]
#   source_security_group_ids = [aws_security_group.sonar_qube.id]
#   from_port         = var.jenkins_port
#   to_port           = var.jenkins_port
#   ip_protocol       = var.ip_protocol_name
# }

# Jenkins egress rule (allow all outbound traffic)
resource "aws_vpc_security_group_egress_rule" "jenkins_egress" {
  security_group_id = aws_security_group.jenkins.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# ---------------------------------------------
# Jenkins Role And Policy For S3 Bucket Access
# ---------------------------------------------
resource "aws_iam_role" "jenkins_s3_access" {
  name = var.jenkins_s3_role_name
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Principal = {
            Service = "ec2.amazonaws.com"
          },
          Action = "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_policy" "jenkins_s3_policy" {
  name        = var.jenkins_s3_policy_name
  description = "Policy to allow Jenkins access to a specific S3 bucket"
  policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "s3:GetObject",
            "s3:ListBucket",
            "s3:PutObject"
          ],
          Resource = [
            "arn:aws:s3:::${var.environment}-bucket-test-reports-chatapp",
            "arn:aws:s3:::${var.environment}-bucket-test-reports-chatapp/*"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_policy_attachment" "jenkins_s3_attach" {
  name       = var.jenkins_s3_attach_name
  policy_arn = aws_iam_policy.jenkins_s3_policy.arn
  roles      = [aws_iam_role.jenkins_s3_access.name]
}
# -----------------------------------------------------
# Jenkins Role createion For ECR Access
# -----------------------------------------------------
resource "aws_iam_role" "jenkins_ecr_access" {
  name = var.jenkins_ecr_role_name
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Principal = {
            Service = "ec2.amazonaws.com"
          },
          Action = "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_instance_profile" "jenkins_instance_profile" {
  name = var.jenkins_insta_profile_name
  role = aws_iam_role.jenkins_s3_access.name
}

# ----------------------------
# Jenkins instance Creation
# ----------------------------
resource "aws_instance" "jenkins_instance" {
  ami                  = var.amis[0]
  instance_type        = var.inst_type[0]
  # subnet_id            = data.aws_subnet.pub_subnet.id
  # subnet_id = aws_subnet.pub_subnet.id
  subnet_id = var.pub_subnet
  iam_instance_profile = aws_iam_instance_profile.jenkins_instance_profile.name
  #   security_groups = aws_security_group.jenkins.id
  # vpc_security_group_ids = data.aws_security_group.jenkins.id
  vpc_security_group_ids = [aws_security_group.jenkins.id]
  key_name               = var.key_pair_name

  # Enable the Termination Protection
  # disable_api_termination = true
  # Enable the stop Protection
  # disable_api_stop = true
  root_block_device {
    volume_size = var.volume_size[2]
  }
  user_data = filebase64("${path.module}/jenkins_userdata.sh")

  tags = {
    Name        = var.jenkins_server_name
    Environment = var.environment
  }
}


# ----------------------------
# SonarQube Security Group
# ----------------------------
resource "aws_security_group" "sonar_qube" {
  name        = "${var.environment}-${var.sonar_qube_name}-SG"
  description = "Allow SonarQube browser access"
  # vpc_id      = data.aws_vpc.vpc_main.id
  # vpc_id      = aws_vpc.vpc_main.id
  vpc_id = var.vpc_id

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
# SonarQube ingress rule (only from my_ip)
resource "aws_vpc_security_group_ingress_rule" "sonar_ssh_access" {
  security_group_id = aws_security_group.sonar_qube.id
  cidr_ipv4         = var.my_ip
  from_port         = var.ssh_access_for_sg
  to_port           = var.ssh_access_for_sg
  ip_protocol       = var.ip_protocol_name
}
# SonarQube ingress rule for Jenkins (only from Jenkins)
resource "aws_security_group_rule" "from_jenkins_to_sonar" {
  type                     = "ingress"
  from_port                = var.sonar_port
  to_port                  = var.sonar_port
  protocol                 = var.ip_protocol_name
  security_group_id        = aws_security_group.sonar_qube.id
  source_security_group_id = aws_security_group.jenkins.id # Allow traffic from Jenkins SG
}
# resource "aws_vpc_security_group_ingress_rule" "jenkins_sonar_access" {
#   security_group_id = aws_security_group.sonar_qube.id
#   # source_security_group_id       = [aws_security_group.jenkins.id]
#   from_port         = var.sonar_port
#   to_port           = var.sonar_port
#   ip_protocol       = var.ip_protocol_name
# }
# SonarQube egress rule (allow all outbound traffic)
resource "aws_vpc_security_group_egress_rule" "sonar_egress_rule" {
  security_group_id = aws_security_group.sonar_qube.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
# sonar Qube instance 
resource "aws_instance" "sonar_qube_instance" {
  ami           = var.amis[0]
  instance_type = var.inst_type[0]
  # subnet_id     = data.aws_subnet.pub_subnet.id
  # subnet_id     = aws_subnet.pub_subnet.id
  subnet_id = var.pub_subnet
  #   security_groups = aws_security_group.jenkins.id
  # vpc_security_group_ids = data.aws_security_group.sonar_qube.id
  vpc_security_group_ids = [aws_security_group.sonar_qube.id]
  key_name               = var.key_pair_name

  # Enable Termination Protection
  # disable_api_termination = true

  # Enable Stop Protection
  # disable_api_stop = true

  root_block_device {
    volume_size = var.volume_size[1]
  }
  user_data = filebase64("${path.module}/sonar_qube_userdata.sh")
  tags = {
    Name        = var.sonar_qube_server_name
    Environment = var.environment
  }
}

# ------------------------------------------
# jump host server security group creation
# ------------------------------------------

# ----------------------------
# Jump Host Security Group
# ----------------------------
resource "aws_security_group" "jump_host" {
  name        = "${var.environment}-${var.jump_host_sg_name}-SG"
  description = "Allow Jump Host for SSH"
  # vpc_id      = data.aws_vpc.vpc_main.id
  # vpc_id      = aws_vpc.vpc_main.id
  vpc_id = var.vpc_id

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

# jump host server creation
resource "aws_instance" "jump_host_instance" {
  ami           = var.amis[0]
  instance_type = var.inst_type[1]
  # subnet_id     = data.aws_subnet.pub_subnet.id
  # subnet_id     = aws_subnet.pub_subnet.id
  subnet_id = var.pub_subnet
  #   security_groups = aws_security_group.jenkins.id
  vpc_security_group_ids = [aws_security_group.jump_host.id]
  key_name               = var.key_pair_name

  # Enable termination protection 
  # disable_api_termination = true

  root_block_device {
    volume_size = var.volume_size[0]
  }

  tags = {
    Name        = var.jump_host_name
    Environment = var.environment
  }
}