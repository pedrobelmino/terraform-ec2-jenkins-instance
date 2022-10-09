data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"] #virtualização assistida por hardware
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "cwitalks_terraform_ec2_1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"
  key_name = "terraform" # Insira o nome da chave criada antes.
  subnet_id = "${aws_subnet.cwitalks-subnet-public-1.id}"
  vpc_security_group_ids = [aws_security_group.permitir_ssh_http.id]
  associate_public_ip_address = true

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install docker.io -y",
      "sudo service docker start",
      "sudo chmod 666 /var/run/docker.sock",
      "docker run -d -v /home/ubuntu/jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -p 80:8080 -p 5000:5000 pedrobelmino/jenkins-with-docker:latest --name jenkins"
    ]
  }
  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("../terraform.pem")
      timeout     = "4m"
   }


  tags = {
    Name = "cwitalksterraform"
 # Insira o nome da instância de sua preferência.
  }
}


