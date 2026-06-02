# key pair

resource "aws_key_pair" "my_key_new" {
    key_name = "master-infra-app-key"
    public_key = file("terra-key-ec2.pub")
}

#VPC and Security Group

resource "aws_default_vpc" "default" {

}

# SECURITY GROUP

resource "aws_security_group" "master_sg" {

  name        = "ansible-master-sg"
  description = "Security Group for Ansible Master"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "SSH"

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ansible-master-sg"
  }
}




# ANSIBLE MASTER INSTANCE

resource "aws_instance" "ansible_master" {

  ami           = "ami-0fe18bc3cfa53a248"
  instance_type = "t2.medium"

  key_name = aws_key_pair.my_key_new.key_name

  vpc_security_group_ids = [
    aws_security_group.master_sg.id
  ]

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "ansible-master"
    Role = "control-node"
  }
}

# OUTPUTS


output "master_public_ip" {
  value = aws_instance.ansible_master.public_ip
}

output "master_private_ip" {
  value = aws_instance.ansible_master.private_ip
}