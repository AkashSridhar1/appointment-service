provider "aws" {
  region = "us-west-2"
}

module "network" {
  source     = "../../modules/network"
  cidr_block = "10.0.0.0/16"
  azs        = ["us-east-1a", "us-east-1b"]
}

module "iam" {
  source = "../../modules/iam"
}

module "security" {
  source = "../../modules/security"
  vpc_id = module.network.vpc_id
}

# Appointment Service Task Definition
resource "aws_ecs_task_definition" "appointment" {
  family                   = "appointment-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = module.iam.ecs_task_execution_role_arn
  container_definitions    = jsonencode([
    {
      name      = "appointment-service"
      image     = "<appointment_ecr_repo_url>:latest"
      portMappings = [{ containerPort = 3000, hostPort = 3000 }]
      environment = []
    }
  ])
}

# Patient Service Task Definition
resource "aws_ecs_task_definition" "patient" {
  family                   = "patient-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = module.iam.ecs_task_execution_role_arn
  container_definitions    = jsonencode([
    {
      name      = "patient-service"
      image     = "<patient_ecr_repo_url>:latest"
      portMappings = [{ containerPort = 3001, hostPort = 3001 }]
      environment = []
    }
  ])
}

resource "aws_ecs_cluster" "main" {
  name = "appointment-patient-cluster"
}

resource "aws_ecs_service" "appointment" {
  name            = "appointment-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.appointment.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = [for s in module.network.public_subnet_ids : s]
    assign_public_ip = true
    security_groups  = [module.security.security_group_id]
  }
}

resource "aws_ecs_service" "patient" {
  name            = "patient-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.patient.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = [for s in module.network.public_subnet_ids : s]
    assign_public_ip = true
    security_groups  = [module.security.security_group_id]
  }
}
