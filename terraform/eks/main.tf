resource "aws_eks_cluster" "this" {
  name     = "${var.project_name}-eks-cluster"
  role_arn = var.eks_role_arn

  vpc_config {
    subnet_ids         = split(",", var.subnet_ids)
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
  subnet_ids      = split(",", var.subnet_ids)

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
  public_key = file(var.ssh_key_path)

  tags = {
    created_by_me = "TRUE"
  }
}