#####################################################
# PROVIDER
#####################################################
provider "aws" {
  region = var.region
}

#####################################################
# VPC
#####################################################
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "react-vpc"
  }
}

#####################################################
# SUBNET
#####################################################
resource "aws_subnet" "main_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"

  tags = {
    Name = "react-subnet"
  }
}

#####################################################
# INTERNET GATEWAY
#####################################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "react-igw"
  }
}

#####################################################
# ROUTE TABLE
#####################################################
resource "aws_route_table" "main_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "react-rt"
  }
}

resource "aws_route_table_association" "rt_assoc" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.main_rt.id
}

#####################################################
# SECURITY GROUP
#####################################################
resource "aws_security_group" "ec2_sg" {
  name        = "react-app-sg"
  description = "Allow SSH, HTTP, Jenkins, and SonarQube"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SonarQube"
    from_port   = 9000
    to_port     = 9000
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
    Name = "react-app-sg"
  }
}

#####################################################
# IAM ROLE & INSTANCE PROFILE
#####################################################
resource "aws_iam_role" "ec2_role" {
  name = "react-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "react-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

#####################################################
# EC2 INSTANCE
#####################################################
# Get latest Amazon Linux 2 AMI dynamically
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "react_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = "devops_keypair"
  subnet_id              = aws_subnet.main_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  #####################################################
# PROVIDER
#####################################################
provider "aws" {
  region = var.region
}

#####################################################
# VPC
#####################################################
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "react-vpc"
  }
}

#####################################################
# SUBNET
#####################################################
resource "aws_subnet" "main_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"

  tags = {
    Name = "react-subnet"
  }
}

#####################################################
# INTERNET GATEWAY
#####################################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "react-igw"
  }
}

#####################################################
# ROUTE TABLE
#####################################################
resource "aws_route_table" "main_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "react-rt"
  }
}

resource "aws_route_table_association" "rt_assoc" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.main_rt.id
}

#####################################################
# SECURITY GROUP
#####################################################
resource "aws_security_group" "ec2_sg" {
  name        = "react-app-sg"
  description = "Allow SSH, HTTP, Jenkins, and SonarQube"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SonarQube"
    from_port   = 9000
    to_port     = 9000
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
    Name = "react-app-sg"
  }
}

#####################################################
# IAM ROLE & INSTANCE PROFILE
#####################################################
resource "aws_iam_role" "ec2_role" {
  name = "react-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "react-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

#####################################################
# EC2 INSTANCE
#####################################################
# Get latest Amazon Linux 2 AMI dynamically
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "react_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = "devops_keypair"
  subnet_id              = aws_subnet.main_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id] 
  associate_public_ip_address = true
  user_data              = file("user_data.sh")
  tags = {
    Name = "react-server"
  }
}


#####################################################
# OUTPUT
#####################################################
output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.react_server.public_ip
}

output "jenkins_url" {
  value = "http://${aws_instance.react_server.public_ip}:8080"
}

output "sonarqube_url" {
  value = "http://${aws_instance.react_server.public_ip}:9000"
}


  user_data              = file("user_data.sh")
  tags = {
    Name = "react-server"
  }
}


#####################################################
# OUTPUT
#####################################################
output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.react_server.public_ip
}

output "jenkins_url" {
  value = "http://${aws_instance.react_server.public_ip}:8080"
}

output "sonarqube_url" {
  value = "http://${aws_instance.react_server.public_ip}:9000"
}

