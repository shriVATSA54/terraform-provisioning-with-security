module "vpc" {
  source               = "./module/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  availability_zones   = var.availability_zones
  private_subnet_cidrs = var.private_subnet_cidrs

}

module "alb" {
  source     = "./module/alb"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
  allow_80 = var.allow_80
}

module "asg" {
  source              = "./module/asg"
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.public_subnet_ids
  target_group_arns   = [module.alb.target_group_arn]
  alb_sg_id           = module.alb.alb_sg_id
  ami_id              = var.ami_id
  key_name            = var.key_name
  asg_min_size        = var.asg_min_size
  asg_max_size        = var.asg_max_size
  asg_desired         = var.asg_desired
  on_demand_base      = var.on_demand_base
  on_demand_pct_above = var.on_demand_pct_above
}
