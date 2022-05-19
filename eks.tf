##EKS Cluster id
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}
  
##EKS cluster auth
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
##Kubernetes provider 
provider "kubernetes" {
  host                   = data.aws_eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.11"
}  

## Availability zones 
data "aws_availabiltity_zones" "available" {
}
  
  
  
  
  to be continued
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.environment}-${var.owner}-${random_id.id.hex}"
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = var.vpc_enable_nat_gateway
  single_nat_gateway = var.vpc_single_nat_gateway

  tags = {
    Terraform   = "true"
    Environment = terraform.workspace
  }
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.16.0"

  depends_on = [
    module.vpc,
    module.efs
  ]

  cluster_name    = "${var.environment}-${var.owner}-${random_id.id.hex}"
  cluster_version = "1.21"
  subnets         = concat(module.vpc.public_subnets, module.vpc.private_subnets)
  vpc_id          = module.vpc.vpc_id
  manage_aws_auth = false
  enable_irsa     = true
  workers_group_defaults = {
    instance_type        = "t2.micro"   #AMD based processor
    subnets              = module.vpc.private_subnets
    asg_desired_capacity = 1
    asg_min_size         = 2
    asg_max_size         = 3
  }
  
  node_groups = {
    worker = {
      version = "1.21"
      capacity_type = "SPOT"  #using AWS SPOT instance for testing, should change when it comes to production
    }
  }
}
