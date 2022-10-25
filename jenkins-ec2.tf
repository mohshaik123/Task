resource "aws_security_group" "jenkins" {
  name        = "jenkins"
  description = "Allow TLS inbound traffic"
  vpc_id      = "vpc-0052be00b8afb6dca"

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "jenkins.sg"
  }
}

resource "aws_instance" "jenkins-ec2" {
  ami                    = "ami-017c001a88dd93847"
  instance_type          = "t2.2xlarge"
  vpc_security_group_ids = [aws_security_group.jenkins.id]
  subnet_id              = "subnet-0e63cfb27c90f21d2"
  key_name               = aws_key_pair.keypair.id
  user_data              = <<-EOF
              #!/bin/bash
              sudo su -
wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
    rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    yum upgrade -y
    amazon-linux-extras install java-openjdk11
    yum install jenkins -y
    systemctl start jenkins
systemctl enable jenkins
              EOF



  tags = {
    Name = "jenkins-ec2"
  }
}