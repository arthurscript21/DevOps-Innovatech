resource "aws_ecs_cluster" "main" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "app" {
  family                   = "app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  
  # CAMBIO AQUÍ: Usamos el LabRole existente del laboratorio
  execution_role_arn       = "arn:aws:iam::667130977262:role/LabRole"
  task_role_arn            = "arn:aws:iam::667130977262:role/LabRole"

  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = "${aws_ecr_repository.backend.repository_url}:latest"
      essential = true
      portMappings = [{ containerPort = 8080, hostPort = 8080 }]
    },
    {
      name      = "frontend"
      image     = "${aws_ecr_repository.frontend.repository_url}:latest"
      essential = true
      portMappings = [{ containerPort = 80, hostPort = 80 }]
    }
  ])
}

resource "aws_ecs_service" "main" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = ["subnet-071becf07692c2e04"]
    assign_public_ip = true
    security_groups  = ["sg-0770225d6fe1a71d1"]
  }
}