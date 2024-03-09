resource "aws_eip" "jumper-dmz" {
  tags = {
    Name = "jumper-dmz"
  }

  instance = aws_instance.jumper-dmz.id
}

resource "aws_key_pair" "ec2-jumper-ssh-pub" {
  key_name   = "ec2-jumper-ssh-pub"
  public_key = var.ec2-jumper-ssh-pub
}

resource "aws_instance" "jumper-dmz" {
  ami = "ami-081a36454cdf357cb"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg-dmz-jumper.id]

  subnet_id = aws_subnet.dmz-jumper-a.id
  key_name = aws_key_pair.ec2-jumper-ssh-pub.id
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
