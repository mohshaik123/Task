resource "aws_security_group" "app1-tomcat" {
  name        = "app1-tomcat"
  description = "app1-tomcat"
  vpc_id      = "vpc-0052be00b8afb6dca"

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

   ingress {
    description      = "TLS from VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "app1-tomcat"
  }
}

resource "aws_instance" "tomcat-app1" {
  ami           = "ami-017c001a88dd93847"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.app1-tomcat.id]
  subnet_id              = "subnet-0e63cfb27c90f21d2"
  key_name               = aws_key_pair.keypair.id

  tags = {
    Name = "tomcat-app1"
  }
}