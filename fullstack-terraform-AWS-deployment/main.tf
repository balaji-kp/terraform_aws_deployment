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
}









