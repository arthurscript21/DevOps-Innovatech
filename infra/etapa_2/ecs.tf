# --- 1. CLUSTER Y ROLES ---
resource "aws_ecs_cluster" "main" {
  name = var.cluster_name
}

# (Opcional, pero recomendado) Crear grupo de logs para ver errores
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${var.cluster_name}"
  retention_in_days = 7
}

# --- 2. DEFINICIÓN DE LA TAREA ---
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
      environment = [
        { name = "SPRING_DATASOURCE_URL", value = "jdbc:mysql://${aws_instance.database.private_ip}:3306/ventas_db" },
        { name = "SPRING_DATASOURCE_USERNAME", value = "root" },
        { name = "SPRING_DATASOURCE_PASSWORD", value = "rootpassword" }
      ]
      # AÑADIDO: Configuración de logs del profe
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name,
          awslogs-region        = "us-east-1", # Cambia esto si no usas us-east-1
          awslogs-stream-prefix = "ventas"
        }
      }
    },
    {
      name      = "backend-despachos"
      image     = "${aws_ecr_repository.back_despachos.repository_url}:latest"
      essential = true
      portMappings = [{ containerPort = 8081, hostPort = 8081 }]
      environment = [
        { name = "SPRING_DATASOURCE_URL", value = "jdbc:mysql://${aws_instance.database.private_ip}:3306/despachos_db" },
        { name = "SPRING_DATASOURCE_USERNAME", value = "root" },
        { name = "SPRING_DATASOURCE_PASSWORD", value = "rootpassword" }
      ]
      # AÑADIDO: Configuración de logs
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name,
          awslogs-region        = "us-east-1",
          awslogs-stream-prefix = "despachos"
        }
      }
    },
    {
      name      = "frontend"
      image     = "${aws_ecr_repository.frontend.repository_url}:latest"
      essential = true
      portMappings = [{ containerPort = 80, hostPort = 80 }]
      
      # AÑADIDO: Dependencia para que espere a los backends
      dependsOn = [
        { containerName = "backend-ventas", condition = "START" },
        { containerName = "backend-despachos", condition = "START" }
      ]

      # AÑADIDO: Configuración de logs
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name,
          awslogs-region        = "us-east-1",
          awslogs-stream-prefix = "frontend"
        }
      }
    }
  ])
}

# --- 3. SERVICIO ECS ---
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