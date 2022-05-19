data "aws_eks_cluster" "kwara-cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "kwara-cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.kwara-cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.kwara-cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.kwara-cluster.token
  #load_config_file       = false
}


module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name                    = "kwara-cluster"
  cluster_version                 = "1.21"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  vpc_id     = aws_vpc.dev-vpc.id
  subnet_ids = [aws_subnet.dev1-subnet.id, aws_subnet.dev2-subnet.id]

  # If the instance is too small, you will not have enough available NICs to assign IP addresses to
  # all the pods on your instances

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    disk_size              = 20
    instance_types         = ["t2.nano", "t3.small", "t2.micro"]
    vpc_security_group_ids = [aws_security_group.allow-web-traffic.id]
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 2
      max_size     = 5
      desired_size = 1

      instance_types = ["t3.small"]
      capacity_type  = "SPOT"
      labels = {
        Environment = "test"
        GithubRepo  = "terraform-aws-eks"
        GithubOrg   = "terraform-aws-modules"
      }
      taints = {
        dedicated = {
          key    = "dedicated"
          value  = "gpuGroup"
          effect = "NO_SCHEDULE"
        }
      }
      tags = {
        ExtraTag = "example"
      }
    }
  }
}
      #additional_security_group_ids = [aws_security_group.allow-web-traffic.id]
 
