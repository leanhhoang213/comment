resource "aws_ecs_task_definition" "hoangla_task_defi" {
  family                   = "hoangla-task-defi"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  container_definitions = jsonencode([
    {
      name  = "hoangla_task_defi"
      image = "356705062463.dkr.ecr.us-east-2.amazonaws.com/hoangla-ecr:v1.2"
      portMappings = [
        {
          containerPort = 80 #9001
          hostPort      = 80 #9001
        }
      ]
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "aws-waf-logs-test-ecs"
          awslogs-region        = "us-east-2"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
    ]
  )
  execution_role_arn = aws_iam_role.hoangla_ecs_role.arn
}
resource "aws_ecs_service" "hoangla_service_ecs" {
  name            = "hoangla-ecs"
  cluster         = aws_ecs_cluster.hoangla_cluster.id
  task_definition = aws_ecs_task_definition.hoangla_task_defi.id
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = [aws_subnet.hoangla_private_subnet_1.id, aws_subnet.hoangla_private_subnet_2.id, aws_subnet.hoangla_private_subnet_3.id]
    security_groups  = [aws_security_group.hoangla_sg_ecs.id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.hoangla_tg.arn
    container_name   = "hoangla_task_defi"
    container_port   = 80
  }
}
resource "aws_ecs_cluster" "hoangla_cluster" {
  name = "hoangla-cluster"
  tags = {
    Name = "hoangla-cluster"
  }
}

