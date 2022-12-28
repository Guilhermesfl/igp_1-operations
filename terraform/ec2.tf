resource "aws_security_group" "TF_SG" {
  name        = "IGP - TF_SG"
  description = "IGP - TF_SG"
  vpc_id      = "vpc-9dba61f7"

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "TF SG"
  }
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "TF_admin_key_pair" {
  key_name   = "TF_admin_key_pair"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "TF_admin_key_pair" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tfkey"
  file_permission = "0400"
}

resource "aws_instance" "jenkins_master_server" {
  ami           = "ami-06ce824c157700cd2"
  instance_type = "t2.large"
  security_groups = [ "${aws_security_group.TF_SG.name}" ]
  key_name = aws_key_pair.TF_admin_key_pair.key_name

  tags = {
    Name = "Jenkins Master"
  }
}

resource "aws_instance" "jenkins_slave_server" {
  ami           = "ami-06ce824c157700cd2"
  instance_type = "t2.large"
  security_groups = [ "${aws_security_group.TF_SG.name}" ]
  key_name = aws_key_pair.TF_admin_key_pair.key_name

  tags = {
    Name = "Jenkins Slave"
  }
}

resource "aws_instance" "kubernetes_server" {
  ami           = "ami-06ce824c157700cd2"
  instance_type = "t2.large"
  security_groups = [ "${aws_security_group.TF_SG.name}" ]
  key_name = aws_key_pair.TF_admin_key_pair.key_name

  tags = {
    Name = "Kubernetes Server"
  }
}