output "ecr_repository_url" {
  description = "AWS ECR Docker Repository URL"
  value       = aws_ecr_repository.app_repo.repository_url
}

output "cloudfront_domain_name" {
  description = "CloudFront Distribution Domain Name (Global CDN URL)"
  value       = "https://${aws_cloudfront_distribution.cf.domain_name}"
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS Name (Direct HTTPS/HTTP entry point)"
  value       = "https://${aws_lb.alb.dns_name}"
}

output "rds_endpoint" {
  description = "Amazon RDS MySQL Endpoint"
  value       = aws_db_instance.mysql.endpoint
}

output "phpmyadmin_url" {
  description = "URL to access phpMyAdmin"
  value       = "http://${aws_lb.alb.dns_name}:8080"
}
