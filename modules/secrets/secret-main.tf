# Creates Secrets in AWS Secret Manager

resource "random_uuid" "secret" {
}
resource "aws_secretsmanager_secret" "appdynamics-access-secret" {
  name  = "APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY_${random_uuid.secret.result}"
}



resource "aws_secretsmanager_secret_version" "appdynamics-access-secret" {

  secret_id     = aws_secretsmanager_secret.appdynamics-access-secret.id
  secret_string = var.appdynamics-access-secret
}


output "appdynamics-access-secret-arn" {
  value = aws_secretsmanager_secret_version.appdynamics-access-secret.arn
}


output "appdynamics-access-secret-name" {
  value = aws_secretsmanager_secret.appdynamics-access-secret.name
}
