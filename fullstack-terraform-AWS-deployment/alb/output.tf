output web-tier-alb-endpoint{
 value = aws_lb.web-tier-alb.dns_name
}
output app-tier-alb-endpoint{
 value = aws_lb.app-tier-alb.dns_name
}
