terraform {
    required_version = "~> 0.13.4"
}

provider "aws" {
  access_key                  = "localstack_access_key"
  region                      = "eu-west-1"
  s3_force_path_style         = true
  secret_key                  = "lolcalstack_secret_key"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  profile                     = var.profile
  shared_credentials_file = "~/.aws/credentials"
  region                      = var.aws_region

  endpoints {
    apigateway     = "http://localhost:4566"
    cloudformation = "http://localhost:4566"
    cloudwatch     = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
    es             = "http://localhost:4566"
    eks            = "http://localhost:4566"
    firehose       = "http://localhost:4566"
    iam            = "http://localhost:4566"
    kinesis        = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    route53        = "http://localhost:4566"
    redshift       = "http://localhost:4566"
    s3             = "http://localhost:4566"
    secretsmanager = "http://localhost:4566"
    ses            = "http://localhost:4566"
    sns            = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    ssm            = "http://localhost:4566"
    stepfunctions  = "http://localhost:4566"
    sts            = "http://localhost:4566"
  }
}

# locals, developer and admin users groups for eks cluster
locals {
  admin_user_map_users = [
    for admin_user in var.admin_users :
    {
      userarn  = "arn:aws:iam::${var.account_id}:user/${admin_user}"
      username = admin_user
      groups   = ["system:masters"]
    }
  ]
  developer_user_map_users = [
    for developer_user in var.developer_users :
    {
      userarn  = "arn:aws:iam::${var.account_id}:user/${developer_user}"
      username = developer_user
      groups   = ["${var.name_prefix}-developers"]
    }
  ]
  cluster_name = "${terraform.workspace}-${var.name_prefix}-eks-cluster"
}

module "vpc" {
  source                      = "terraform-aws-modules/vpc/aws"
  version                     = "~> 2.0"
  name                        = "${terraform.workspace}-${var.name_prefix}-vpc"
  cidr                        = var.vpc_cidr
  azs                         = var.azs
  private_subnets             = var.private_subnets_cidrs
  public_subnets              = var.public_subnets_cidrs
  database_subnets            = var.db_subnets_cidrs
  enable_nat_gateway          = true
  single_nat_gateway          = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                                                           = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"                                                  = "1"
  }
}

module "eks" {
  source                      = "terraform-aws-modules/eks/aws"
  version                     = "~> 1.9"
  cluster_name                = local.cluster_name
  cluster_version             = var.cluster_version
  subnets                     = module.vpc.private_subnets
  vpc_id                      = module.vpc.vpc_id
  enable_irsa                 = true
  write_kubeconfig            = false
  cluster_enabled_log_types   = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  worker_groups = [
    {
      instance_type           = var.instance_type
      asg_desired_capacity    = var.asg_desired_capacity
      asg_min_size            = var.asg_min_size
      asg_max_size            = var.asg_max_size
      tags = [{
        key                   = "environment"
        value                 = "${terraform.workspace}"
        propagate_at_launch   = true
      }]
    }
  ]

  tags = {
    environment               = "${terraform.workspace}"
  }
}