provider "aws" {
 region = "ap-south-1"
}

module "vpc"{
 source="./vpc"
 vpc_cidr="11.0.0.0/16"
}

module "ec2"{
 source="./ec2"
 webSG=module.vpc.webSG
 public-subnet=module.vpc.public-subnet
 web-tier-sub1=module.vpc.web-tier-sub1
 web-tier-sub2=module.vpc.web-tier-sub2
 app-tier-sub1=module.vpc.app-tier-sub1
 app-tier-sub2=module.vpc.app-tier-sub2
 rds-endpoint=module.rds.rds-endpoint
 web-tier-alb-endpoint=module.alb.web-tier-alb-endpoint
 app-tier-alb-endpoint=module.alb.app-tier-alb-endpoint
 ec2_s3_role_name=module.IAM-role.ec2_s3_role_name
}

module "alb"{
 source="./alb"
 vpc-id=module.vpc.vpc-id
 webSG=module.vpc.webSG
 web-tier-sub1=module.vpc.web-tier-sub1
 web-tier-sub2=module.vpc.web-tier-sub2
 web-instance-1=module.ec2.web-instance-1
 web-instance-2=module.ec2.web-instance-2
 app-tier-sub1=module.vpc.app-tier-sub1
 app-tier-sub2=module.vpc.app-tier-sub2
 app-instance-1=module.ec2.app-instance-1
 app-instance-2=module.ec2.app-instance-2
}

module "rds"{
 source="./rds"
 vpc-id=module.vpc.vpc-id
 db-tier-sub1=module.vpc.db-tier-sub1
 db-tier-sub2=module.vpc.db-tier-sub2
}

module "web-tier-ASG" {
  source           = "./web-tier-ASG"
  vpc_id           = module.vpc.vpc-id
  subnet1          = module.vpc.web-tier-sub1
  subnet2          = module.vpc.web-tier-sub2
  target_group_arn = module.alb.alb_target_group_arn
  app-tier-alb-endpoint=module.alb.app-tier-alb-endpoint
}

output web-tier-alb-endpoint{
 value = module.alb.web-tier-alb-endpoint
}
output app-tier-alb-endpoint{
 value = module.alb.app-tier-alb-endpoint
}

module "app-tier-asg" {
  source           = "./app-tier-asg"
  vpc_id           = module.vpc.vpc-id
  subnet1          = module.vpc.app-tier-sub1
  subnet2          = module.vpc.app-tier-sub2
  target_group_arn = module.alb.app-alb_target_group_arn
  web-tier-alb-endpoint=module.alb.web-tier-alb-endpoint
  rds-endpoint=module.rds.rds-endpoint
}







