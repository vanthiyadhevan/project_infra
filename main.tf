# Base Module file

# data "local_file" "config_file" {
#   filename = "environment/${var.environment}/config.yml"
# }

# locals {
#   base_config = {
#     env        = var.environment
#     aws_region = var.region
#     # aws_account_id = var.aws_account_id
#     yaml-config-data = yamldecode(data.local_file.config_file.content)

#   }
#   vpc-name   = local.base_config.yaml-config-data.vpc.Name
#   cidr-block = local.base_config.yaml-config-data.vpc.cidr-block
# }

# Backend section
# terraform {
#   backend "s3" {

#   }
# }

# module "rds" {
#   source    = "./modules/rds"
#   count     = var.environment == "staging" ? 1 : 0
#   vpc_id    = module.vpc.vpc_id
#   subnet_id = module.vpc.pvt_subnet
#   # base_config = local.base_config
#   depends_on = [module.vpc]
# }
# module "bucket" {
#   source     = "./modules/S3"
#   count      = var.environment == "staging" ? 1 : 0
#   depends_on = [module.vpc]

# }
module "vpc" {
  source = "./modules/vpc"
  # base_config = locals.base_config
}
module "eks" {
  source     = "./modules/eks"
  vpc_id     = module.vpc.vpc_id
  vpc_cidr   = module.vpc.vpc_cidr # Ensure this is a valid attribute in vpc module
  pub_subnet = module.vpc.pub_subnet
  # pvt_subnet = module.vpc.pvt_subnet[*].id
  pvt_subnet = module.vpc.pvt_subnet

  depends_on = [module.vpc]
}
module "compute_servers" {
  source     = "./modules/compute"
  count      = var.environment == "staging" ? 1 : 0
  my_ip      = var.my_ip
  vpc_id     = module.vpc.vpc_id
  pub_subnet = module.vpc.pub_subnet[0]
  # subnet_id = module.vpc.pub_subnet[0].id
  depends_on = [
    module.vpc
  ]
  #  security_group_ids = [module.security_group.id] # Ensure security group module outputs `id`

}
# module "security_group" {
#   source = "./modules/SG"
#   vpc_id = module.vpc_vpc_id.id
#   my_ip  = var.my_ip

#   # depends_on = [module.vpc]
# }


