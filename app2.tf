resource "aws_security_group" "app2-tomcat" {
  name        = "app2-tomcat"
  description = "app2-tomcat"
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
    Name = "app2-tomcat"
  }
}

resource "aws_instance" "tomcat-app2" {
  ami           = "ami-017c001a88dd93847"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.app2-tomcat.id]
  subnet_id              = "subnet-0e63cfb27c90f21d2"
  key_name               = aws_key_pair.keypair.id
  user_data = <<-EOF
              sudo su -
              wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.68/bin/apache-tomcat-9.0.68-windows-x64.zip
              unzip  apache-tomcat-9.0.68-windows-x64.zip
              cd apache-tomcat-9.0.68
              amazon-linux-extras install java-openjdk11
              cd bin/
              chmod 755 *.sh
              ./startup.sh
              EOF

  tags = {
    Name = "tomcat-app2"
  }
}