# Refer to the docs for a detailed description of the variables - https://docs.appdynamics.com/display/latest/Java+Agent+Configuration+Properties

variable "APPDYNAMICS_CONTROLLER_HOST_NAME" {
  type        = string
  description = "The controller host name without http(s) or port number."

  validation {
    condition     = length(var.APPDYNAMICS_CONTROLLER_HOST_NAME) > 4 && substr(var.APPDYNAMICS_CONTROLLER_HOST_NAME, 0, 4) != "http"
    error_message = "The APPDYNAMICS_CONTROLLER_HOST_NAME value must NOT be empty or null, and must not contain http(s)."
  }
}

variable "APPDYNAMICS_CONTROLLER_PORT" {
  type    = string
  default = "443"
}

variable "APPDYNAMICS_CONTROLLER_SSL_ENABLED" {
  type    = bool
  default = true
}

variable "APPDYNAMICS_AGENT_APPLICATION_NAME" {
  type = string
  validation {
    condition     = length(var.APPDYNAMICS_AGENT_APPLICATION_NAME) > 0
    error_message = "The APPDYNAMICS_AGENT_APPLICATION_NAME value must NOT be empty or null."
  }
}

variable "APPDYNAMICS_AGENT_TIER_NAME" {
  type = string

  validation {
    condition     = length(var.APPDYNAMICS_AGENT_TIER_NAME) > 0
    error_message = "The APPDYNAMICS_AGENT_TIER_NAME value must NOT be empty or null."
  }

}

variable "APPDYNAMICS_AGENT_ACCOUNT_NAME" {
  type        = string
  description = "The AppDynamics controller account name."

  validation {
    condition     = length(var.APPDYNAMICS_AGENT_ACCOUNT_NAME) > 0
    error_message = "The APPDYNAMICS_AGENT_ACCOUNT_NAME value must NOT be empty or null."
  }
}

variable "APPDYNAMICS_AGENT_REUSE_NODE_NAME_PREFIX" {
  type = string
}

variable "APPDYNAMICS_AGENT_REUSE_NODE_NAME" {
  type    = bool
  default = true
}

variable "APPDYNAMICS_EVENTS_API_URL" {
  type = string
  validation {
    condition     = length(var.APPDYNAMICS_EVENTS_API_URL) > 4 && substr(var.APPDYNAMICS_EVENTS_API_URL, 0, 4) == "http"
    error_message = "The APPDYNAMICS_EVENTS_API_URL value contain the full URL string and port number, for example: 'https://<host>:9080' ."
  }
}

variable "APPDYNAMICS_GLOBAL_ACCOUNT_NAME" {
  type = string
  validation {
    condition     = length(var.APPDYNAMICS_GLOBAL_ACCOUNT_NAME) > 0
    error_message = "The APPDYNAMICS_GLOBAL_ACCOUNT_NAME value must NOT be empty or null."
  }
}



variable "CORECLR_ENABLE_PROFILING" {
  type = string
  default = "1"
}
variable "CORECLR_PROFILER" {
  type = string
  default = "{57e1aa68-2229-41aa-9931-a6e93bbc64d8}"
}
variable "CORECLR_PROFILER_PATH" {
  type = string
  default =  "/opt/appdynamics-agent/dotnet/libappdprofiler.so"
}


variable "APPDYNAMICS_AGENT_IMAGE" {
  type = string
}

variable "APPDYNAMICS_AGENT_CONTAINER_NAME" {
  type = string
}