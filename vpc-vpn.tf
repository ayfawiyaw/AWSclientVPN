resource "aws_vpc" "myvpc" {
  cidr_block = "19.0.0.0/20"
  tags = {
    Name = "MyVPC"
  }
}

resource "aws_subnet" "PublicSubnet" {
  vpc_id            = aws_vpc.myvpc.id
  availability_zone = "us-east-1a"
  cidr_block        = "19.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnet"
  }
}

resource "aws_subnet" "PrivSubnet" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "19.0.2.0/24"
  map_public_ip_on_launch = false
  tags = {
    Name = "PrivateSubnet"
  }
}

resource "aws_internet_gateway" "myIgw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "MyIGW"
  }
}

resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myIgw.id
  }

  tags = {
    Name = "PublicRT"
  }
}

resource "aws_route_table_association" "PublicRTAssociation" {
  subnet_id      = aws_subnet.PublicSubnet.id
  route_table_id = aws_route_table.PublicRT.id
}

resource "aws_security_group" "PublicSG" {
  vpc_id = aws_vpc.myvpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "PublicSG"
  }
}

resource "aws_security_group" "PrivateSG" {
  vpc_id = aws_vpc.myvpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["19.0.1.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "PrivateSG"
  }
}

resource "aws_key_pair" "MyKey" {
  key_name   = "MyKey"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "PublicInstance" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.PublicSubnet.id
  key_name      = aws_key_pair.MyKey.key_name
  security_groups = [aws_security_group.PublicSG.name]

  tags = {
    Name = "PublicInstance"
  }
}

resource "aws_instance" "PrivateInstance" {
  ami           = "ami-04505e74c0741db8d" 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.PrivSubnet.id
  key_name      = aws_key_pair.MyKey.key_name
  security_groups = [aws_security_group.PrivateSG.name]

  tags = {
    Name = "PrivateInstance"
  }
}
