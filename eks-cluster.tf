provider "kubernetes" {
  host = data.aws_eks_cluster.myapp-cluster.endpoint
  token = data.aws_eks_cluster_auth.myapp-cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.myapp-cluster.certificate_authority.0.data)
}

data "aws_eks_cluster" "myapp-cluster" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "myapp-cluster" {
  name = module.eks.cluster_name
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.20.0"

  cluster_name = "myapp-eks-cluster"
  cluster_version = "1.28"

  subnet_ids = module.myapp-vpc.private_subnets
  vpc_id = module.myapp-vpc.vpc_id

  tags = {
    environment = "development"
    application = "myapp"
  }
  
  eks_managed_node_groups = {
    first = {
      desired_capacity = 2
      max_capacity = 3
      min_capacity = 1

      instance_type = "t2.medium"
    }
  }
}