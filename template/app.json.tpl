[
    {
        "Name": "${container_name}",
        "Image": "${container_image}",
        "PortMappings": [
            {
                "containerPort": ${container_port},
                "hostPort": ${container_port},
                "protocol": "tcp"
            }
        ],
        "Essential": true,
        "DependsOn": [
            {
                "containerName": "${APPDYNAMICS_AGENT_CONTAINER_NAME}",
                "condition": "COMPLETE"
            }
        ],
        "mountPoints": [
            {
                "sourceVolume": "appd-agent-volume",
                "containerPath": "/opt/appdynamics-agent/dotnet",
                "readOnly": false
            }
        ],
        "Command": [
            "/bin/sh",
            "-c",
            "ls /opt/appdynamics-agent/dotnet"
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${aws_cloudwatch_log_group}",
                "awslogs-region": "${region}",
                "awslogs-stream-prefix": "ecs"
            }
        },
        "secrets": [
            {
                "name": "APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY",
                "valueFrom": "${APPDYNAMICS_ACCOUNT_ACCESS_KEY_ARN}"
            }
        ],
        "environment": [
            {
                "name": "APPDYNAMICS_CONTROLLER_HOST_NAME",
                "value": "${APPDYNAMICS_CONTROLLER_HOST_NAME}"
            },
            {
                "name": "APPDYNAMICS_CONTROLLER_PORT",
                "value": "${APPDYNAMICS_CONTROLLER_PORT}"
            },
            {
                "name": "APPDYNAMICS_CONTROLLER_SSL_ENABLED",
                "value": "${APPDYNAMICS_CONTROLLER_SSL_ENABLED}"
            },
            {
                "name": "APPDYNAMICS_AGENT_ACCOUNT_NAME",
                "value": "${APPDYNAMICS_AGENT_ACCOUNT_NAME}"
            },
            {
                "name": "APPDYNAMICS_AGENT_APPLICATION_NAME",
                "value": "${APPDYNAMICS_AGENT_APPLICATION_NAME}"
            },
            {
                "name": "APPDYNAMICS_AGENT_TIER_NAME",
                "value": "${APPDYNAMICS_AGENT_TIER_NAME}"
            },
            {
                "name": "APPDYNAMICS_AGENT_REUSE_NODE_NAME",
                "value": "${APPDYNAMICS_AGENT_REUSE_NODE_NAME}"
            },
            {
                "name": "APPDYNAMICS_AGENT_REUSE_NODE_NAME_PREFIX",
                "value": "${APPDYNAMICS_AGENT_REUSE_NODE_NAME_PREFIX}"
            },
            {
                "name": "CORECLR_PROFILER",
                "value": "${CORECLR_PROFILER}"
            },
            {
                "name": "CORECLR_ENABLE_PROFILING",
                "value": "${CORECLR_ENABLE_PROFILING}"
            },
            {
                "name": "CORECLR_PROFILER_PATH",
                "value": "${CORECLR_PROFILER_PATH}"
            }
        ]
    },
    {
        "Name": "${APPDYNAMICS_AGENT_CONTAINER_NAME}",
        "Image": "${APPDYNAMICS_AGENT_IMAGE}",
        "Essential": false,
        "Command": [
            "/bin/sh",
            "-c",
            "cp -r /opt/appdynamics/. /opt/temp"
        ],
        "mountPoints": [
            {
                "sourceVolume": "appd-agent-volume",
                "containerPath": "/opt/temp",
                "readOnly": false
            }
        ]
    }
]
