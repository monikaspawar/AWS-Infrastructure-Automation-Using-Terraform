output "target_group_arn" {
  value = aws_lb_target_group.ecs_target_group.arn
}

output "listener_arn" {
  value = aws_lb_listener.http.arn
}

output "alb_arn" {
  value = aws_lb.app_lb.arn
}

output "alb_dns_name" {
  value = aws_lb.app_lb.dns_name
}