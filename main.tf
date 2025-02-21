provider "aws" {
  region = "ap-south-1" # Change region if needed
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP traffic"
  vpc_id      = data.aws_vpc.default.id  # Fetch default VPC

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami             = "ami-0ddfba243cbee3768" # Amazon Linux 2 (Change based on region)
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.web_sg.name]
  key_name        = "worldly" # Replace with your key pair name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo '${file("index.html")}' > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = "Terraform-Web-Server"
  }
}

output "website_ip" {
  value = aws_instance.web.public_ip
}
