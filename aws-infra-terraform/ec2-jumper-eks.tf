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
