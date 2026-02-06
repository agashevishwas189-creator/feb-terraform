provider "aws" {
    region = "ap-south-1"
    profile = "configs"
  
}
resource "aws_instance" "webserver" {
    ami = var.ami_webserver
    instance_type = var.webserver_type
    vpc_security_group_ids = ["sg-0c78535db3865697a", aws_security_group.web_sg.id , data.aws_security_group.my_web_sg.id]
    disable_api_termination = var.webserver_termination
    count = var.webserver_copy
    
    tags = {
        Name = "webserver"
    }
    user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install httpd -y
                sudo systemctl start httpd
                sudo systemctl enable httpd
                echo "<h1>Welcome to Terraform Web Server</h1>" > /var/www/html/index.html
                EOF
    }
    resource "aws_security_group" "web_sg" {

        ingress {
            from_port = "80"
            to_port = "80"
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
      
    }
        ingress {
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
        tags = {
            Name = "modified-web-sg"
        }
    }    

    data "aws_security_group" "my_web_sg" {
        name = "jenkins-demo"
    }