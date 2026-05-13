output "alb_dns_endpoint" {
  value       = "http://${aws_lb.photoshare_alb.dns_name}"
  description = "Akses dengan URL berikut dan di port 80"
}

output "alb_securitygroup_id" {
  value = aws_security_group.photoshare_alb_securitygroup.id
}

output "alb_dns_name" {
  value = aws_lb.photoshare_alb.dns_name
}