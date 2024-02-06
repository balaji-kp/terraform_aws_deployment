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
 web-tier-sub1=module.vpc.web-tier-sub1
 web-tier-sub2=module.vpc.web-tier-sub2
 app-tier-sub1=module.vpc.app-tier-sub1
 app-tier-sub2=module.vpc.app-tier-sub2
}

module "alb"{
 source="./alb"
 vpc-id=moduel.vpc.vpc-id
 webSG=module.vpc.webSG
 web-tier-sub1=module.vpc.web-tier-sub1
 web-tier-sub2=module.vpc.web-tier-sub2
 web-instance-1=module.ec2.web-instance-1
 web-instance-2=module.ec2.web-instance-1
 
}









