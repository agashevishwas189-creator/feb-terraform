output "output_webserver_sg" {
    value = aws_security_group.web_sg.id
}
output "alb_dns_name" {
    value = aws_alb.app_lb.dns_name
  
}