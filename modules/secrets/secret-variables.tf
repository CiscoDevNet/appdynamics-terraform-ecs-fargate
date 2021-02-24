variable "name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

variable "appdynamics-access-secret" {
  description = "appdynamics controller secret Formatted like ENV_VAR = VALUE"
}

