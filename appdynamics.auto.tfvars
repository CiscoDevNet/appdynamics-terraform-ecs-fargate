### AppDynamics specific variables are CAPITALISED ##### 
#Change app name and tier name via CI/CD tooling
APPDYNAMICS_AGENT_APPLICATION_NAME = "TF_ECS_Sample_App"
APPDYNAMICS_AGENT_TIER_NAME        = "dotnetcore-API"

# These variables are fairly contant per controller 
APPDYNAMICS_AGENT_ACCOUNT_NAME           = "fieldlabs"
APPDYNAMICS_AGENT_REUSE_NODE_NAME_PREFIX = "Node"
APPDYNAMICS_AGENT_REUSE_NODE_NAME        = true
APPDYNAMICS_CONTROLLER_HOST_NAME         = "fieldlabs.saas.appdynamics.com"
APPDYNAMICS_CONTROLLER_PORT              = "443"
APPDYNAMICS_CONTROLLER_SSL_ENABLED       = "true"
APPDYNAMICS_EVENTS_API_URL               = "https://analytics.api.appdynamics.com:443"
APPDYNAMICS_GLOBAL_ACCOUNT_NAME          = "fieldlabs_66c17af8-fcc7-4c41-a7a7-f7c088ac8d5e"
CORECLR_ENABLE_PROFILING                 = "1"
CORECLR_PROFILER                         = "{57e1aa68-2229-41aa-9931-a6e93bbc64d8}"
CORECLR_PROFILER_PATH                    = "/opt/appdynamics-agent/dotnet/libappdprofiler.so"
APPDYNAMICS_AGENT_IMAGE                  = "appdynamics/dotnet-core-agent:21.7.0"
APPDYNAMICS_AGENT_CONTAINER_NAME         = "AppDynamicsAgentContainer"
