LAB para criação de um container ec2 jenkins utilizando terraform
============================

**Pré-requisitos**
- AWSCli
- Terraform

**Criação de Service account**
- Crie uma service account em https://us-east-1.console.aws.amazon.com/iamv2/home

**Criação do par de chaves para acesso SSH, de preferência com o nome 'terraform'**
- https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#KeyPairs:
- Baixar arquivo pem 'terraform.pem' e deixar um nível acima da pasta do projeto

**Inicialização**
```bash
terraform init
```

**Planejamento**
```bash
terraform plan
```

**Aplicação da infra estrutura**
```bash
terraform apply
```

**Destruição da infra estrutura**
```bash
terraform destroy
```

**Acesso ao container via ssh**
```bash
ssh -i "../terraform.pem" [IP]
```

**Conectado na instância EC2, recuperar chave de acesso**
```bash
sudo docker logs jenkins  
```

**Acesso e configuração do jenkins**
- Acessar http://[IP]:80

**Faça bom proveito!**

