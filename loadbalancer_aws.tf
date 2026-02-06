
data "aws_vpc" "default" {
    default = true
}
data "aws_subnet" "default" {
    filter {
        name = "vpc-id"
        values = [data.aws_vpc.default.id]
    }
}
resource "aws_security_group" "web_sg" {
    name = "web_sg"
    vpc_id = data.aws_vpc.default.id

    ingress {
        from_port = "80"
        to_port = "80"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress = {
        from_port = "0"
        to_port = "0"
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = "0"
        to_port = "0"
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_alb" "app_lb" {
    name = "app-lb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.web_sg.id]
    subnets = data.aws_subnet.default.id 
}
resource "aws_lb_target_group" "app_tg" {
    name = "app-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id
  
}
resource "aws_lb_listener" "app_listener" {
    load_balancer_arn = aws_alb.app_lb.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.app_tg.arn
    }
}

resource "aws_launch_template" "example" {
    name_prefix   = "foobar"
    image_id      = var.ami_webserver
    instance_type = var.webserver_type

    network_interfaces {
        associate_public_ip_address = true
        security_groups = [aws_security_group.web_sg.id]
    }
}