resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"


  tags = {
    Name = "dev"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "dev"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "dev_rt"
  }

}

resource "aws_route" "main_route" {
  route_table_id         = aws_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
  depends_on             = [aws_route_table.main]
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "main" {
  name        = "main"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_key_pair" "main" {
  key_name   = "main"
  public_key = file("~/.ssh/main.pub")
}

resource "aws_instance" "main" {
  ami           = data.aws_ami.main.id
  instance_type = "t2.micro"
	key_name = aws_key_pair.main.id
	vpc_security_group_ids = [aws_security_group.main.id]
	subnet_id = aws_subnet.main.id
	user_data = file("userdata.tpl")

	root_block_device {
		volume_size = 10
	}
  tags = {
    Name = "main_ec2"
  }

	provisioner "local-exec" {
		command = templatefile("${var.host_os}-ssh-config.tpl", {
			hostname = self.public_ip,
			user = "ubuntu",
			identityFile = "~/.ssh/main"
		})
		interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
		//interpreter = ["bash", "-c"]
	}
}