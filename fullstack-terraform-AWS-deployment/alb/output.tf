output web-tier-alb-endpoint{
 value = aws_lb.web-tier-alb.dns_name
}
output app-tier-alb-endpoint{
 value = aws_lb.app-tier-alb.dns_name
}
output "alb_target_group_arn" {
  value = aws_lb_target_group.web-tier-tg.arn
}
output "app-alb_target_group_arn" {
  value = aws_lb_target_group.app-tier-tg.arn
}