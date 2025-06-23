variable "vpc_id" {}

resource "aws_security_group" "ecs_service" {
  name        = "ecs-service-sg"
  description = "Allow HTTP"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3000
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "security_group_id" {
  value = aws_security_group.ecs_service.id
}