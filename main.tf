##################
# Blue resources
#################

resource "aws_instance" "blue" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  associate_public_ip_address = false
  subnet_id                   = aws_subnet.blue_orange.id
  security_groups             = [aws_security_group.blue.name]
  tags = {
    Name = "blue"
  }

  # startup script to embed private SSH key in blue instance
  user_data = <<EOF
#!/bin/bash
mkdir -p /home/ubuntu/.ssh
chmod 700 /home/ubuntu/.ssh

cat << 'PRIVATEKEY' > /home/ubuntu/.ssh/id_rsa
${tls_private_key.orange.private_key_pem}
PRIVATEKEY
chmod 600 /home/ubuntu/.ssh/id_rsa

cat << 'PUBLICKEY' > /home/ubuntu/.ssh/id_rsa.pub
${tls_private_key.orange.public_key_openssh}
PUBLICKEY
chmod 644 /home/ubuntu/.ssh/id_rsa.pub

chown -R ubuntu:ubuntu /home/ubuntu/.ssh
EOF

}

resource "aws_security_group" "blue" {
  name   = "blue"
  vpc_id = var.vpc_id
  tags = {
    Name = "blue"
  }
}

resource "aws_ec2_instance_connect_endpoint" "blue" {
  subnet_id          = aws_subnet.blue_orange.id
  security_group_ids = [aws_security_group.blue.id]
  tags = {
    Name = "blue"
  }
}

###############
# Orange resources
###############

resource "aws_instance" "orange" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  associate_public_ip_address = false
  subnet_id                   = aws_subnet.blue_orange.id
  key_name                    = aws_key_pair.orange.key_name
  security_groups             = [aws_security_group.orange.name]
  tags = {
    Name = "orange"
  }

}

resource "aws_security_group" "orange" {
  name   = "orange"
  vpc_id = var.vpc_id
  tags = {
    Name = "orange"
  }
}


# resource "aws_vpc_security_group_ingress_rule" "orange" {
#   security_group_id = aws_security_group.orange.id

#   referenced_security_group_id = aws_security_group.blue.id
#   ip_protocol                  = -1 # -1 means all protocols
#   from_port                    = 22
#   to_port                      = 22

#   description = "Allow SSH traffic from blue security group"
# }


####################
# Global resources
####################
resource "tls_private_key" "orange" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "orange" {
  key_name   = "orange"
  public_key = tls_private_key.orange.public_key_openssh
}

resource "aws_subnet" "blue_orange" {
  vpc_id     = var.vpc_id
  cidr_block = cidrsubnet(data.aws_vpc.blue_orange.cidr_block, 8, 0) # take the first /24 range in the VPC, supposing it's available

  tags = {
    Name = "blue-orange"
  }
}