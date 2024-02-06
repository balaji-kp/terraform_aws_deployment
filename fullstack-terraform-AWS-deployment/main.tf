provider "aws" {
 region = "ap-south-1"
}

module "vpc"{
 source="./vpc"
 vpc_cidr="10.0.0.0/16"
}

module "ec2"{
 source="./ec2"
 vpc_id= module.vpc.vpc_id
}









