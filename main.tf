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

resource "aws_instance" "techtalks_terraform_ec2_1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"
  key_name = "terraform" # Insira o nome da chave criada antes.
  subnet_id = "${aws_subnet.techtalks-subnet-public-1.id}"
  vpc_security_group_ids = [aws_security_group.permitir_ssh_http.id]
  associate_public_ip_address = true

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install docker.io unzip -y",
      "sudo service docker start",
      "sudo chmod 666 /var/run/docker.sock",
      "curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip'",
      "unzip awscliv2.zip",
      "sudo ./aws/install",
      "mkdir /home/ubuntu/.aws"
    ]
  }

  provisioner "file" {
    source      = "/root/.aws/config" # substituir por caminho da config AWS
    destination = "/home/ubuntu/.aws/config"
  }

  provisioner "file" {
    source      = "/root/.aws/credentials" # substituir por caminho da credential AWS
    destination = "/home/ubuntu/.aws/credentials"
  }

  provisioner "remote-exec" {
    inline = [
      "aws s3 cp s3://belmino-jenkins-backup/jenkins-2022-10-15.zip jenkins-2022-10-15.zip", # substituir pelo caminho do backup para bucket/zip do jenkins home
      "unzip jenkins-2022-10-15.zip", # substituir pelo caminho do backup para bucket/zip do jenkins home
      "sudo docker run -d -v /home/ubuntu/jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -p 80:8080 -p 5000:5000 pedrobelmino/jenkins-with-docker:latest"
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
    Name = "techtalksterraform"
 # Insira o nome da instância de sua preferência.
  }
}


