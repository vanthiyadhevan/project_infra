# Base Module file
# This file is used to define the base module for the Terraform configuration.
# The AWS provider is configured to use the "us-east-1" region.
# The base module is essential for managing the infrastructure as code.


module "vpc" {
  source = "./modules/vpc"
}
module "eks" {
  source     = "./modules/eks"
  vpc_id     = module.vpc.vpc_id
  vpc_cidr   = module.vpc.vpc_cidr # Ensure this is a valid attribute in vpc module
  pub_subnet = module.vpc.pub_subnet
  pvt_subnet = module.vpc.pvt_subnet

  depends_on = [module.vpc]
}
module "compute_servers" {
  source     = "./modules/compute"
  count      = var.environment == "staging" ? 1 : 0
  my_ip      = var.my_ip
  vpc_id     = module.vpc.vpc_id
  pub_subnet = module.vpc.pub_subnet[0]
  depends_on = [
    module.vpc
  ]

}


