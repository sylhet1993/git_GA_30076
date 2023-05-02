resource "aws_key_pair" "skintel" {
  key_name   = "skintel-key-pair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCdrqITrwQMxKt+a7a5L8du4hapJdO28nTlZzGRG8o56qIFKxZyUJC9GFQNebsoZ5Hhb87XKouJinfU3w/eP5FK4RVyZJJqCgzQGTbu/Xm91eOh8kslc/q0SaIOTBX8Cr4+4ov+9+l9SJHcK7TcctTzlFCVzG9o1cF9hfFVV0OfztZucy1/wh0BfeAjoVXfnjoMQafsvsaTi7AAdfDrYKJD5Lnbj+1frAr+XuZy1A/EypwG09v8qOG6cK0uLJtydtJus99x7ka59uFlqvbSpKQfUcIqoUtOFl3LNDkWyCPES+txdAscdRT7StXUs20hJ5zuqeTHPHItLxhxVGIFmI2lyTilHwUfOFjKGym+gIor/YFLWHA+xpLUMCPK41E8o2XrGZeQOwS1NCxsngoCFVjlJ5Vd30263RM/D45QdEywIoZkEpU5DHhC++VKu3bRc53Faycnwx9XNPak1KAXhdTPaoGJbWUDJI5koWf2LPTOYNm0kjg2BbGAX4IfkJiKRo0= skintel_dev"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

# EC2 Instance for Mid-Tier
resource "aws_network_interface" "mid_tier_public" {
  subnet_id   = aws_subnet.dev-mid-tier.id
  security_groups = [aws_security_group.dev-default.id]
  tags = {
    Name = "dev_mid_tier"
    Environment = "dev"
  }
}

resource "aws_instance" "mid_tier_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.skintel.key_name
  network_interface {
    network_interface_id = aws_network_interface.mid_tier_public.id
    device_index         = 0
  }
  credit_specification {
    cpu_credits = "unlimited"
  }
  tags = {
    Name = "dev_mid_tier"
    Environment = "dev"
  }
}

# EC2 Instance for Vision
resource "aws_network_interface" "vision_private" {
  subnet_id   = aws_subnet.dev-vision.id
  security_groups = [aws_security_group.dev-default.id]
  tags = {
    Name = "dev_vision"
    Environment = "dev"
  }
}

resource "aws_instance" "vision_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.skintel.key_name
  network_interface {
    network_interface_id = aws_network_interface.vision_private.id
    device_index         = 0
  }
  credit_specification {
    cpu_credits = "unlimited"
  }
  tags = {
    Name = "dev_vision"
    Environment = "dev"
  }
}

# EC2 Instance for Bastion
resource "aws_network_interface" "bastion_public" {
  subnet_id   = aws_subnet.dev-bastion.id
  security_groups = [aws_security_group.dev-default.id]
  tags = {
    Name = "dev_bastion"
    Environment = "dev"
  }
}

resource "aws_instance" "bastion_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.skintel.key_name
  network_interface {
    network_interface_id = aws_network_interface.bastion_public.id
    device_index         = 0
  }
  credit_specification {
    cpu_credits = "unlimited"
  }
  tags = {
    Name = "dev_bastion"
    Environment = "dev"
  }
}