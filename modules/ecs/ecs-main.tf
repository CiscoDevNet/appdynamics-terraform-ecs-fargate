
resource "aws_cloudwatch_log_group" "main" {
  name = "/ecs/${var.name}-task-${var.environment}"

  tags = {
    Name        = "${var.name}-task-${var.environment}"
    Environment = var.environment
  }
}

data "template_file" "task_def" {
  template = file("./template/app.json.tpl")
  vars = {
    container_name =  "${var.name}-container-${var.environment}"
    container_port = var.container_port

    aws_cloudwatch_log_group = aws_cloudwatch_log_group.main.name
    region = var.region
    container_image = var.container_image

    APPDYNAMICS_ACCOUNT_ACCESS_KEY_ARN =  var.container_secrets_arns
    APPDYNAMICS_AGENT_APPLICATION_NAME = var.APPDYNAMICS_AGENT_APPLICATION_NAME
    APPDYNAMICS_AGENT_TIER_NAME        =  var.APPDYNAMICS_AGENT_TIER_NAME

    APPDYNAMICS_AGENT_ACCOUNT_NAME           = var.APPDYNAMICS_AGENT_ACCOUNT_NAME
    APPDYNAMICS_AGENT_REUSE_NODE_NAME_PREFIX = var.APPDYNAMICS_AGENT_REUSE_NODE_NAME_PREFIX
    APPDYNAMICS_CONTROLLER_HOST_NAME         = var.APPDYNAMICS_CONTROLLER_HOST_NAME
    APPDYNAMICS_CONTROLLER_PORT              = var.APPDYNAMICS_CONTROLLER_PORT
    APPDYNAMICS_CONTROLLER_SSL_ENABLED       = var.APPDYNAMICS_CONTROLLER_SSL_ENABLED
    APPDYNAMICS_EVENTS_API_URL               = var.APPDYNAMICS_EVENTS_API_URL
    APPDYNAMICS_GLOBAL_ACCOUNT_NAME          = var.APPDYNAMICS_GLOBAL_ACCOUNT_NAME
    APPDYNAMICS_AGENT_REUSE_NODE_NAME        = var.APPDYNAMICS_AGENT_REUSE_NODE_NAME
    CORECLR_ENABLE_PROFILING                 = var.CORECLR_ENABLE_PROFILING
    CORECLR_PROFILER                         = var.CORECLR_PROFILER
    CORECLR_PROFILER_PATH                    = var.CORECLR_PROFILER_PATH

    APPDYNAMICS_AGENT_IMAGE                  =  var.APPDYNAMICS_AGENT_IMAGE
    APPDYNAMICS_AGENT_CONTAINER_NAME         =  var.APPDYNAMICS_AGENT_CONTAINER_NAME

  }
}


resource "aws_ecs_task_definition" "main" {
  family                   = "${var.name}-task-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = data.template_file.task_def.rendered

  tags = {
    Name        = "${var.name}-task-${var.environment}"
    Environment = var.environment
  }

   volume {
    name      = "appd-agent-volume"
  }

}

resource "aws_ecs_cluster" "main" {
  name = "${var.name}-cluster-${var.environment}"
  tags = {
    Name        = "${var.name}-cluster-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_ecs_service" "main" {
  name                               = "${var.name}-service-${var.environment}"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.main.arn
  desired_count                      = var.service_desired_count
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 60
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = var.ecs_service_security_groups
    subnets          = var.subnets.*.id
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.aws_alb_target_group_arn
    container_name   = "${var.name}-container-${var.environment}"
    container_port   = var.container_port
  }

  # we ignore task_definition changes as the revision changes on deploy
  # of a new version of the application
  # desired_count is ignored as it can change due to autoscaling policy
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name               = "memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 80
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 60
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}
