resource "aws_iam_instance_profile" "jumper-eks" {
  name = "jumper-eks"
  role = aws_iam_role.jumper-eks.name
}

resource "aws_key_pair" "jumper-eks-ssh-pub" {
  key_name   = "jumper-eks-ssh-pub"
  public_key = var.ec2-jumper-ssh-pub
}

resource "aws_instance" "jumper-eks" {
  ami = "ami-081a36454cdf357cb"
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    aws_security_group.sg-private-jumper.id,
    module.eks.cluster_primary_security_group_id
  ]

  user_data = <<EOF
  #!/bin/bash

  # install kubectl
  curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.5/2024-01-04/bin/linux/amd64/kubectl 
  chmod +x ./kubectl
  mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH

  # install terraform
  sudo yum install -y yum-utils
  sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
  sudo yum -y install terraform

  # install git and clone projects
  sudo yum install -y git
  git clone https://github.com/FRESH-TUNA/eks-prom-thanos-grafana-argocd-stack 

  EOF
  
  iam_instance_profile = aws_iam_instance_profile.jumper-eks.name
  subnet_id = aws_subnet.private-jumper-a.id
  key_name = aws_key_pair.jumper-eks-ssh-pub.id

  disable_api_termination = true

  root_block_device {
    volume_size = "30"
    volume_type = "gp3"
    delete_on_termination = true
    # tags = {
    #   Name = "${var.project_name}-${var.environment}-bastion-ec2"
    # }
  }

#   tags = {
#     Name = "${var.project_name}-${var.environment}-bastion-ec2"
#   }
}
