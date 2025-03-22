resource "aws_eks_cluster" "this" {
  name     = "${var.project_name}-eks-cluster"
  role_arn = var.eks_role_arn

  access_config {
    authentication_mode = "API"
  }

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [var.security_group_id]
  }

  tags = {
    created_by_me = "TRUE"
  }
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.project_name}-node"
  node_role_arn   = var.ec2_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t2.micro"]
  disk_size     = 20

  remote_access {
    ec2_ssh_key = aws_key_pair.eks_key_pair.key_name
  }

  tags = {
    created_by_me = "TRUE"
  }
}

resource "aws_key_pair" "eks_key_pair" {
  key_name   = "eks_key_pair"
  public_key = var.public_key

  tags = {
    created_by_me = "TRUE"
  }
}

resource "aws_eks_access_entry" "this" {
  cluster_name = aws_eks_cluster.this.name
  principal_arn = var.admin_arn

  access_policies {
    policy_arn  = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
    access_scope {
      type = "cluster"
    }
  }
}