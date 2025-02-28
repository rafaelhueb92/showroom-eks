resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group-${var.project_name}"
  description = "Allow inbound HTTP/HTTPS traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust if needed
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust if needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "eks_alb" {
  name               = "eks-alb-${var.project_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = split(",", var.subnet_ids)

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "eks_target" {
  name     = "eks-target-group-${var.project_name}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip" # Use "instance" if registering EC2 instances instead of pods
  health_check {
    path                = "/health" # Adjust based on your app
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.eks_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks_target.arn
  }
}

resource "aws_lb_target_group_attachment" "eks_targets" {
  count            = length(var.eks_pod_ips) 
  target_group_arn = aws_lb_target_group.eks_target.arn
  target_id        = var.eks_service_dns
  port             = 80
}
