# REGIN
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "region to deploy the infra"
}
# VARIABLE ENVIRONMENT
variable "environment" {
  type        = string
  default     = "staging"
  description = "for different environmets"
  nullable    = false
}


# VPC CREATION VARIABLES
variable "vpc_cidr" {
  type = map(string)
  default = {
    "dev"     = "10.1.0.0/16"
    "staging" = "10.2.0.0/16"
    "prod"    = "10.3.0.0/16"
  }
}


# SUBNET CREATION VARIABLES

variable "pub_subnet_cidr" {
  type = map(list(string))
  default = {
    "dev"     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
    "staging" = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
    "prod"    = ["10.3.1.0/24", "10.3.2.0/24", "10.3.3.0/24"]
  }
  description = "public subet for all the environments"
}

variable "pvt_subnet_cidr" {
  type = map(list(string))
  default = {
    "dev"     = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
    "staging" = ["10.2.4.0/24", "10.2.5.0/24", "10.2.6.0/24"]
    "prod"    = ["10.3.4.0/24", "10.3.5.0/24", "10.3.6.0/24"]
  }
  description = "private subnet for all environment"
}


# ROUTE TABLE CREATION
variable "route_table_route_cidr" {
  type        = string
  default     = "0.0.0.0/0"
  description = "route table cidr to route the traffic"
}


# RDS SUBNET GROUP CREATION 
variable "db_subnet_grp_name" {
  type = string
  default = "main_db_subnet_grp"
  description = "db subnet group name"
}

