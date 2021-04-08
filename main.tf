terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}


provider "aws" {
  #access_key = var.aws-access-key
  #secret_key = var.aws-secret-key
  region = var.aws-region
  #version    = "~> 2.0"
  profile = "default"
}


module "vpc" {
  source             = "./vpc"
  name               = var.name
  cidr               = var.cidr
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
  environment        = var.environment
}

module "security_groups" {
  source         = "./security-groups"
  name           = var.name
  vpc_id         = module.vpc.id
  environment    = var.environment
  container_port = var.container_port
}

module "ecr" {
  source      = "./ecr"
  name        = var.name
  environment = var.environment
}


module "secrets" {
  source                    = "./modules/secrets"
  name                      = var.name
  environment               = var.environment
  appdynamics-access-secret = var.APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY
}


module "ecs" {
  source                      = "./modules/ecs"
  name                        = var.name
  environment                 = var.environment
  region                      = var.aws-region
  subnets                     = module.vpc.private_subnets
  aws_alb_target_group_arn    = module.alb.aws_alb_target_group_arn
  ecs_service_security_groups = [module.security_groups.ecs_tasks]
  container_port              = var.container_port
  container_cpu               = var.container_cpu
  container_memory            = var.container_memory
  container_image             = var.container_image
  service_desired_count       = var.service_desired_count
  container_environment = [
    { name = "LOG_LEVEL",
    value = "DEBUG" },
    { name = "PORT",
    value = var.container_port }
  ]
  container_secrets_arns = module.secrets.appdynamics-access-secret-arn
  container_secrets      = "test"

  APPDYNAMICS_AGENT_APPLICATION_NAME = var.APPDYNAMICS_AGENT_APPLICATION_NAME
  APPDYNAMICS_AGENT_TIER_NAME        = var.APPDYNAMICS_AGENT_TIER_NAME

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
  APPDYNAMICS_AGENT_IMAGE          = var.APPDYNAMICS_AGENT_IMAGE
  APPDYNAMICS_AGENT_CONTAINER_NAME = var.APPDYNAMICS_AGENT_CONTAINER_NAME


}


module "alb" {
  source              = "./alb"
  name                = var.name
  vpc_id              = module.vpc.id
  subnets             = module.vpc.public_subnets
  environment         = var.environment
  alb_security_groups = [module.security_groups.alb]
  alb_tls_cert_arn    = var.tsl_certificate_arn
  health_check_path   = var.health_check_path
}
