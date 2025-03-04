
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

locals {
  name             = "${var.app_name}-${var.env}"
  azs              = slice(data.aws_availability_zones.available.names, 0, 3)
  current_identity = data.aws_caller_identity.current.arn
  tags = {
    Terraform   = "true"
    Environment = var.env
    Owner       = "crewmeister"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = local.name
  cidr = "10.0.0.0/16"

  azs              = local.azs
  private_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr_block, 8, k + 1)]
  public_subnets   = [for k, v in local.azs : cidrsubnet(var.vpc_cidr_block, 8, k + 4)]
  database_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr_block, 8, k + 7)]

  private_subnet_names  = ["private-subnet-1", "private-subnet-2"]
  public_subnet_names   = ["public-subnet-1", "public-subnet-2"]
  database_subnet_names = ["db-subnet-1", "db-subnet-2"]

  # Single NAT Gateway
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  tags = local.tags

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${local.name}-eks"
  cluster_version = "1.32"

  authentication_mode                      = "API_AND_CONFIG_MAP"
  cluster_endpoint_public_access           = true
  cluster_endpoint_public_access_cidrs     = ["0.0.0.0/0"]
  create_cloudwatch_log_group              = true
  create_cluster_security_group            = true
  create_iam_role                          = true
  create_kms_key                           = true
  create_node_iam_role                     = true
  create_node_security_group               = true
  enable_irsa                              = true
  enable_cluster_creator_admin_permissions = true

  node_iam_role_additional_policies = {
    ecr_access = aws_iam_policy.eks_ecr_access_policy.arn
  }

  # EKS Addons
  cluster_addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni    = {}
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    example = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2_x86_64"
      instance_types = ["t3.medium"]

      min_size = 2
      max_size = 5
      # This value is ignored after the initial creation
      # https://github.com/bryantbiggs/eks-desired-size-hack
      desired_size = 2
    }
  }

  tags = local.tags
}
