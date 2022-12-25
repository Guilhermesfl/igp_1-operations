resource "aws_instance" "jenkins_master_server" {
  ami           = "ami-0a261c0e5f51090b1"
  instance_type = "t2.micro"

  tags = {
    Name = "Jenkins Master"
  }
}

resource "aws_instance" "jenkins_slave_server" {
  ami           = "ami-0a261c0e5f51090b1"
  instance_type = "t2.micro"

  tags = {
    Name = "Jenkins Slave"
  }
}