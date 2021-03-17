# Automate ECS Fargate instrumentation using Terraform 

Amazon Elastic Container Service (ECS) is a scalable container management service that makes it easy to run, stop, and manage Docker containers on Amazon EC2 clusters.

This project demonstrates how AppDynamics agents can be embedded into an existing ECS/Fargate Terraform using Terraform. 

To ensure that the customer's application image is kept intact, and that the deployment process is immutable,  we have leveraged AWS CloudFormation's Depends-On feature to dynamically acquire the AppDynamics agent image from a Dockerhub, copy the content of the agent image into an emphemeral volume, then configure mount the shared volume into the main application's container at runtime. 


# Resources
This demo creates the following AWS resources:

- VPC
- One public and one private subnet per AZ
- Routing tables for the subnets
- Internet Gateway for public subnets
- NAT gateways with attached Elastic IPs for the private subnet
- Security groups - that allows access to the specified container port
- An Application Load Balancer (ALB) -  with listeners for port 80
- An ECS cluster with a service - inculding auto scaling policies for CPU and memory usage, 
   -  Task definition to run docker containers - an init container for `AppDynamics` and the main container application
   -  IAM execution role
- Secrets - Creates secrets in Secret Manager

![aws](https://user-images.githubusercontent.com/2548160/111489223-da447980-8731-11eb-8dc7-260ab6c63121.png)
(Source: https://aws.amazon.com/de/blogs/compute/task-networking-in-aws-fargate/)

# AppDynamics Specific Changes 

- The main logic is in the <a href="https://github.com/Appdynamics/appdynamics-terraform-ecs-fargate/blob/main/template/app.json.tpl">`template/app.json.tpl`</a> this file. Please review the `DependsOn` section and the AppDynamics environment variables.  
- Create AppDyamics secret in  <a href="https://github.com/Appdynamics/appdynamics-terraform-ecs-fargate/blob/main/secrets.auto.tfvars.example">`secrets.auto.tfvars`</a> Remove .example from the file name. 
- Populate <a href="https://github.com/Appdynamics/appdynamics-terraform-ecs-fargate/blob/main/appdynamics.auto.tfvars">`appdynamics.auto.tfvars`</a> with your controller credentials and the agent's container registry. 


# Run it

We need to setup the Terraform provider to talk to an AWS account. Please refer to <a href="https://github.com/Appdynamics/appdynamics-terraform-ecs-fargate/blob/main/main.tf">`main.tf`</a>

```yaml
provider "aws" {
  access_key = var.aws-access-key
  secret_key = var.aws-secret-key
  region     = "eu-central-1"
  version    = "~> 2.0"
}
```

You can actually also leave out access_key and secret_key, then Terraform will use the profile values stored in your .aws/config 

Next, execute the following commands:

### Sets up Terraform to run
`$ terraform init`

### View Proposed execution plan 
`$ terraform plan`

### Executes the Terraform run
`$ terraform apply`


