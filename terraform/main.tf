provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "web" {
  ami           = "ami-019715e0d74f695be"
  instance_type = "t3.micro"
  key_name      = "jenkinskkp.pem"

  vpc_security_group_ids = ["sg-07c6a5252b519a3c2"]

  tags = {
    Name = "jenkins-game-server"
  }
}

output "public_ip" {
  value = aws_instance.web.public_ip
}
