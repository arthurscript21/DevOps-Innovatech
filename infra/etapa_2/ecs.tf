resource "aws_ecs_cluster" "main" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "app" {
  family                   = "app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "2048"
  memory                   = "4096"
 
  execution_role_arn       = "arn:aws:iam::667130977262:role/LabRole"
  task_role_arn            = "arn:aws:iam::667130977262:role/LabRole"

  container_definitions = jsonencode([
    {
      name      = "backend-ventas"
      image     = "${aws_ecr_repository.back_ventas.repository_url}:latest"
      essential = true
      portMappings = [{ containerPort = 8080, hostPort = 8080 }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/innovatech"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [
        { name = "DB_ENDPOINT", value = aws_instance.database.private_ip },
        { name = "DB_PORT",     value = "3306" },
        { name = "DB_NAME",     value = "ventas_db" },
        { name = "DB_USERNAME", value = "root" },
        { name = "DB_PASSWORD", value = "rootpassword" },
        { name = "JAVA_TOOL_OPTIONS", value = "-Xms256m -Xmx512m" }
      ]
    },
    {
      name      = "backend-despachos"
      image     = "${aws_ecr_repository.back_despachos.repository_url}:latest"
      essential = true
      portMappings = [{ containerPort = 8081, hostPort = 8081 }]
      environment = [
        { name = "DB_ENDPOINT", value = aws_instance.database.private_ip },
        { name = "DB_PORT",     value = "3306" },
        { name = "DB_NAME",     value = "despachos_db" },
        { name = "DB_USERNAME", value = "root" },
        { name = "DB_PASSWORD", value = "rootpassword" },
        { name = "JAVA_TOOL_OPTIONS", value = "-Xms256m -Xmx512m" } 
      ]
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
    subnets          = [aws_subnet.public_subnet.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.sg_innovatech.id]
  }
}