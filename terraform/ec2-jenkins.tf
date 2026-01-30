# EC2 Instance
resource "aws_instance" "ec2-jenkins" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.jenkins_ec2_profile.name
  key_name               = var.key_name
  
   # Increase root volume size
  root_block_device {
    volume_size = 20     # size in GB
    volume_type = "gp3"  # General Purpose SSD
    delete_on_termination = true

  tags = {
    Name = "${var.project_name}-ec2-jenkins"
  }
}

  tags = {
    Name = "${var.project_name}-ec2-jenkins"
  }
}

# Latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

}
